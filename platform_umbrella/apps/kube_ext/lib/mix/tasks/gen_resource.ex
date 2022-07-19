defmodule Mix.Tasks.GenResource do
  @moduledoc "The mix task to generate a resource code module from yaml"
  use Mix.Task

  @requirements ["app.config"]

  def run(args) do
    [file_path, app_name] = args

    methods =
      file_path
      |> YamlElixir.read_all_from_file!()
      |> Enum.reject(&Enum.empty?/1)
      |> Enum.map(fn resource -> process_resource(resource) end)

    module = full_module(app_name, methods)

    resource_path =
      Path.join(File.cwd!(), "apps/kube_resources/lib/kube_resources/#{app_name}.ex")

    File.write!(resource_path, Macro.to_string(module))
  end

  def process_resource(resource) do
    {resource_type, rest} = split_resource_type(resource)
    method_name = resource_method_name(resource_type, resource)

    rest
    |> Enum.reduce(starting_code(resource_type), fn {key, value}, acc_code ->
      handle_field(key, value, acc_code)
    end)
    |> then(fn rp ->
      resource_method_from_pipeline(rp, method_name)
    end)
  end

  defp handle_field("metadata" = _field_name, field_value, acc_code) do
    name = Map.get(field_value, "name", nil)
    namespace = Map.get(field_value, "namespace", nil)

    acc_code
    |> add_name(name)
    |> add_namespace(namespace)
    |> add_app_labels()
  end

  defp handle_field("spec" = _field_name, field_value, acc_code) do
    add_spec(acc_code, field_value)
  end

  defp handle_field(field_name, field_value, acc_code) do
    add_map_put_key(acc_code, field_name, field_value)
  end

  defp pipe(left, right) do
    quote do
      unquote(left) |> unquote(right)
    end
  end

  defp add_map_put_key(pipeline, key, value) do
    pipe(
      pipeline,
      quote do
        Map.put(unquote(key), unquote(value))
      end
    )
  end

  defp add_spec(pipeline, value) do
    pipe(
      pipeline,
      quote do
        B.spec(unquote(value))
      end
    )
  end

  defp add_name(pipeline, name) do
    pipe(
      pipeline,
      quote do
        B.name(unquote(name))
      end
    )
  end

  defp add_app_labels(pipeline) do
    pipe(
      pipeline,
      quote do
        B.app_labels(@app)
      end
    )
  end

  defp add_namespace(pipeline, nil), do: pipeline

  defp add_namespace(pipeline, _namespace) do
    pipe(
      pipeline,
      quote do
        B.namespace(namespace)
      end
    )
  end

  def split_resource_type(resource) do
    resource_type = KubeExt.ApiVersionKind.resource_type(resource)

    {resource_type, Map.drop(resource, ["apiVersion", "kind"])}
  end

  def starting_code(resource_type) do
    quote do
      B.build_resource(unquote(resource_type))
    end
  end

  def resource_method_name(resource_type, resource) do
    name =
      resource
      |> K8s.Resource.name()
      |> Macro.underscore()
      |> String.replace(~r/[^a-zA-Z\d]/, "_")

    :"#{Atom.to_string(resource_type)}_#{name}"
  end

  def resource_method_from_pipeline(pipeline, method_name) do
    quote do
      def unquote(method_name)(config) do
        namespace = Settings.namespace(config)
        unquote(pipeline)
      end
    end
  end

  def full_module(app_name, methods) do
    quote do
      defmodule KubeResources.Resource do
        alias KubeExt.Builder, as: B
        @app unquote(app_name)

        unquote_splicing(methods)
      end
    end
  end
end
