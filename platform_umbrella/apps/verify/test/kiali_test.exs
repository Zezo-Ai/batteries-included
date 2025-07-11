defmodule Verify.KialiTest do
  use Verify.Images

  use Verify.TestCase,
    async: false,
    batteries: ~w(kiali)a,
    images: ~w(grafana kiali)a ++ @victoria_metrics

  verify "kiali is running", %{session: session} do
    session
    |> assert_pod_running("kiali-")
    |> visit("/net_sec")
    |> click_external(Query.css("a", text: "Kiali"))
    # find the link to the website in the footer
    |> assert_has(Query.css(~s|header img[alt="Kiali Logo"]|))
  end
end
