defmodule KubeResources.Rook do
  use KubeExt.IncludeResource,
    cephblockpoolradosnamespaces_ceph_rook_io:
      "priv/manifests/rook/cephblockpoolradosnamespaces_ceph_rook_io.yaml",
    cephblockpools_ceph_rook_io: "priv/manifests/rook/cephblockpools_ceph_rook_io.yaml",
    cephbucketnotifications_ceph_rook_io:
      "priv/manifests/rook/cephbucketnotifications_ceph_rook_io.yaml",
    cephbuckettopics_ceph_rook_io: "priv/manifests/rook/cephbuckettopics_ceph_rook_io.yaml",
    cephclients_ceph_rook_io: "priv/manifests/rook/cephclients_ceph_rook_io.yaml",
    cephclusters_ceph_rook_io: "priv/manifests/rook/cephclusters_ceph_rook_io.yaml",
    cephfilesystemmirrors_ceph_rook_io:
      "priv/manifests/rook/cephfilesystemmirrors_ceph_rook_io.yaml",
    cephfilesystems_ceph_rook_io: "priv/manifests/rook/cephfilesystems_ceph_rook_io.yaml",
    cephfilesystemsubvolumegroups_ceph_rook_io:
      "priv/manifests/rook/cephfilesystemsubvolumegroups_ceph_rook_io.yaml",
    cephnfses_ceph_rook_io: "priv/manifests/rook/cephnfses_ceph_rook_io.yaml",
    cephobjectrealms_ceph_rook_io: "priv/manifests/rook/cephobjectrealms_ceph_rook_io.yaml",
    cephobjectstores_ceph_rook_io: "priv/manifests/rook/cephobjectstores_ceph_rook_io.yaml",
    cephobjectstoreusers_ceph_rook_io:
      "priv/manifests/rook/cephobjectstoreusers_ceph_rook_io.yaml",
    cephobjectzonegroups_ceph_rook_io:
      "priv/manifests/rook/cephobjectzonegroups_ceph_rook_io.yaml",
    cephobjectzones_ceph_rook_io: "priv/manifests/rook/cephobjectzones_ceph_rook_io.yaml",
    cephrbdmirrors_ceph_rook_io: "priv/manifests/rook/cephrbdmirrors_ceph_rook_io.yaml",
    objectbucketclaims_objectbucket_io:
      "priv/manifests/rook/objectbucketclaims_objectbucket_io.yaml",
    objectbuckets_objectbucket_io: "priv/manifests/rook/objectbuckets_objectbucket_io.yaml",
    csi_cephfs_plugin_resource: "priv/raw_files/rook/CSI_CEPHFS_PLUGIN_RESOURCE",
    csi_cephfs_provisioner_resource: "priv/raw_files/rook/CSI_CEPHFS_PROVISIONER_RESOURCE",
    csi_nfs_plugin_resource: "priv/raw_files/rook/CSI_NFS_PLUGIN_RESOURCE",
    csi_nfs_provisioner_resource: "priv/raw_files/rook/CSI_NFS_PROVISIONER_RESOURCE",
    csi_rbd_plugin_resource: "priv/raw_files/rook/CSI_RBD_PLUGIN_RESOURCE",
    csi_rbd_provisioner_resource: "priv/raw_files/rook/CSI_RBD_PROVISIONER_RESOURCE"

  use KubeExt.ResourceGenerator

  import KubeExt.Yaml

  alias KubeExt.Builder, as: B
  alias KubeRawResources.DataSettings, as: Settings

  @app "rook"

  resource(:cluster_role_binding_ceph_global, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-ceph-global")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-global"))
    |> B.subject(B.build_service_account("rook-ceph-system", namespace))
  end

  resource(:cluster_role_binding_ceph_mgr, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-ceph-mgr-cluster")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-mgr-cluster"))
    |> B.subject(B.build_service_account("rook-ceph-mgr", namespace))
  end

  resource(:cluster_role_binding_ceph_object_bucket, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-ceph-object-bucket")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-object-bucket"))
    |> B.subject(B.build_service_account("rook-ceph-system", namespace))
  end

  resource(:cluster_role_binding_ceph_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-ceph-osd")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-osd"))
    |> B.subject(B.build_service_account("rook-ceph-osd", namespace))
  end

  resource(:cluster_role_binding_ceph_system, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-ceph-system")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-system"))
    |> B.subject(B.build_service_account("rook-ceph-system", namespace))
  end

  resource(:cluster_role_binding_ceph_system_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-ceph-system-psp")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-ceph-system", namespace))
  end

  resource(:cluster_role_binding_cephfs_csi_nodeplugin, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("cephfs-csi-nodeplugin")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("cephfs-csi-nodeplugin"))
    |> B.subject(B.build_service_account("rook-csi-cephfs-plugin-sa", namespace))
  end

  resource(:cluster_role_binding_cephfs_csi_provisioner, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("cephfs-csi-provisioner-role")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("cephfs-external-provisioner-runner"))
    |> B.subject(B.build_service_account("rook-csi-cephfs-provisioner-sa", namespace))
  end

  resource(:cluster_role_binding_csi_cephfs_plugin_sa_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-csi-cephfs-plugin-sa-psp")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-csi-cephfs-plugin-sa", namespace))
  end

  resource(:cluster_role_binding_csi_cephfs_provisioner_sa_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-csi-cephfs-provisioner-sa-psp")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-csi-cephfs-provisioner-sa", namespace))
  end

  resource(:cluster_role_binding_csi_rbd_plugin_sa_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-csi-rbd-plugin-sa-psp")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-csi-rbd-plugin-sa", namespace))
  end

  resource(:cluster_role_binding_csi_rbd_provisioner_sa_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rook-csi-rbd-provisioner-sa-psp")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-csi-rbd-provisioner-sa", namespace))
  end

  resource(:cluster_role_binding_rbd_csi_nodeplugin, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rbd-csi-nodeplugin")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rbd-csi-nodeplugin"))
    |> B.subject(B.build_service_account("rook-csi-rbd-plugin-sa", namespace))
  end

  resource(:cluster_role_binding_rbd_csi_provisioner, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:cluster_role_binding)
    |> B.name("rbd-csi-provisioner-role")
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rbd-external-provisioner-runner"))
    |> B.subject(B.build_service_account("rook-csi-rbd-provisioner-sa", namespace))
  end

  resource(:cluster_role_ceph_global) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-global")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["pods", "nodes", "nodes/proxy", "services", "secrets", "configmaps"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["events", "persistentvolumes", "persistentvolumeclaims", "endpoints"],
        "verbs" => ["get", "list", "watch", "patch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["storageclasses"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => ["batch"],
        "resources" => ["jobs", "cronjobs"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["ceph.rook.io"],
        "resources" => [
          "cephclients",
          "cephclusters",
          "cephblockpools",
          "cephfilesystems",
          "cephnfses",
          "cephobjectstores",
          "cephobjectstoreusers",
          "cephobjectrealms",
          "cephobjectzonegroups",
          "cephobjectzones",
          "cephbuckettopics",
          "cephbucketnotifications",
          "cephrbdmirrors",
          "cephfilesystemmirrors",
          "cephfilesystemsubvolumegroups",
          "cephblockpoolradosnamespaces"
        ],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{
        "apiGroups" => ["ceph.rook.io"],
        "resources" => [
          "cephclients/status",
          "cephclusters/status",
          "cephblockpools/status",
          "cephfilesystems/status",
          "cephnfses/status",
          "cephobjectstores/status",
          "cephobjectstoreusers/status",
          "cephobjectrealms/status",
          "cephobjectzonegroups/status",
          "cephobjectzones/status",
          "cephbuckettopics/status",
          "cephbucketnotifications/status",
          "cephrbdmirrors/status",
          "cephfilesystemmirrors/status",
          "cephfilesystemsubvolumegroups/status",
          "cephblockpoolradosnamespaces/status"
        ],
        "verbs" => ["update"]
      },
      %{
        "apiGroups" => ["ceph.rook.io"],
        "resources" => [
          "cephclients/finalizers",
          "cephclusters/finalizers",
          "cephblockpools/finalizers",
          "cephfilesystems/finalizers",
          "cephnfses/finalizers",
          "cephobjectstores/finalizers",
          "cephobjectstoreusers/finalizers",
          "cephobjectrealms/finalizers",
          "cephobjectzonegroups/finalizers",
          "cephobjectzones/finalizers",
          "cephbuckettopics/finalizers",
          "cephbucketnotifications/finalizers",
          "cephrbdmirrors/finalizers",
          "cephfilesystemmirrors/finalizers",
          "cephfilesystemsubvolumegroups/finalizers",
          "cephblockpoolradosnamespaces/finalizers"
        ],
        "verbs" => ["update"]
      },
      %{
        "apiGroups" => ["policy", "apps", "extensions"],
        "resources" => ["poddisruptionbudgets", "deployments", "replicasets"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete", "deletecollection"]
      },
      %{
        "apiGroups" => ["healthchecking.openshift.io"],
        "resources" => ["machinedisruptionbudgets"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["machine.openshift.io"],
        "resources" => ["machines"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["csidrivers"],
        "verbs" => ["create", "delete", "get", "update"]
      },
      %{
        "apiGroups" => ["k8s.cni.cncf.io"],
        "resources" => ["network-attachment-definitions"],
        "verbs" => ["get"]
      }
    ])
  end

  resource(:cluster_role_ceph_mgmt) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-cluster-mgmt")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{
        "apiGroups" => ["", "apps", "extensions"],
        "resources" => [
          "secrets",
          "pods",
          "pods/log",
          "services",
          "configmaps",
          "deployments",
          "daemonsets"
        ],
        "verbs" => ["get", "list", "watch", "patch", "create", "update", "delete"]
      }
    ])
  end

  resource(:cluster_role_ceph_mgr) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-mgr-cluster")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["configmaps", "nodes", "nodes/proxy", "persistentvolumes"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["events"],
        "verbs" => ["create", "patch", "list", "get", "watch"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["storageclasses"],
        "verbs" => ["get", "list", "watch"]
      }
    ])
  end

  resource(:cluster_role_ceph_mgr_system) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-mgr-system")
    |> B.app_labels(@app)
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["configmaps"], "verbs" => ["get", "list", "watch"]}
    ])
  end

  resource(:cluster_role_ceph_object_bucket) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-object-bucket")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["secrets", "configmaps"],
        "verbs" => ["get", "create", "update", "delete"]
      },
      %{"apiGroups" => ["storage.k8s.io"], "resources" => ["storageclasses"], "verbs" => ["get"]},
      %{
        "apiGroups" => ["objectbucket.io"],
        "resources" => ["objectbucketclaims"],
        "verbs" => ["list", "watch", "get", "update"]
      },
      %{
        "apiGroups" => ["objectbucket.io"],
        "resources" => ["objectbuckets"],
        "verbs" => ["list", "watch", "get", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["objectbucket.io"],
        "resources" => ["objectbucketclaims/status", "objectbuckets/status"],
        "verbs" => ["update"]
      },
      %{
        "apiGroups" => ["objectbucket.io"],
        "resources" => ["objectbucketclaims/finalizers", "objectbuckets/finalizers"],
        "verbs" => ["update"]
      }
    ])
  end

  resource(:cluster_role_ceph_osd) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-osd")
    |> B.app_labels(@app)
    |> B.rules([%{"apiGroups" => [""], "resources" => ["nodes"], "verbs" => ["get", "list"]}])
  end

  resource(:cluster_role_ceph_system) do
    B.build_resource(:cluster_role)
    |> B.name("rook-ceph-system")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["pods", "pods/log"], "verbs" => ["get", "list"]},
      %{"apiGroups" => [""], "resources" => ["pods/exec"], "verbs" => ["create"]},
      %{
        "apiGroups" => ["admissionregistration.k8s.io"],
        "resources" => ["validatingwebhookconfigurations"],
        "verbs" => ["create", "get", "delete", "update"]
      }
    ])
  end

  resource(:cluster_role_cephfs_csi_nodeplugin) do
    B.build_resource(:cluster_role)
    |> B.name("cephfs-csi-nodeplugin")
    |> B.app_labels(@app)
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["nodes"], "verbs" => ["get", "list", "watch"]},
      %{"apiGroups" => [""], "resources" => ["namespaces"], "verbs" => ["get", "list"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumes"],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["volumeattachments"],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{"apiGroups" => [""], "resources" => ["configmaps"], "verbs" => ["get", "list"]}
    ])
  end

  resource(:cluster_role_cephfs_external_provisioner_runner) do
    B.build_resource(:cluster_role)
    |> B.name("cephfs-external-provisioner-runner")
    |> B.app_labels(@app)
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["secrets"], "verbs" => ["get", "list"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumes"],
        "verbs" => ["get", "list", "watch", "create", "delete", "update", "patch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumeclaims"],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["storageclasses"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["events"],
        "verbs" => ["list", "watch", "create", "update", "patch"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["volumeattachments"],
        "verbs" => ["get", "list", "watch", "update", "patch"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["volumeattachments/status"],
        "verbs" => ["patch"]
      },
      %{"apiGroups" => [""], "resources" => ["nodes"], "verbs" => ["get", "list", "watch"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumeclaims/status"],
        "verbs" => ["update", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshots"],
        "verbs" => ["get", "list", "watch", "update", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshotcontents"],
        "verbs" => ["create", "get", "list", "watch", "update", "delete", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshotclasses"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshotcontents/status"],
        "verbs" => ["update", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshots/status"],
        "verbs" => ["update", "patch"]
      }
    ])
  end

  resource(:cluster_role_psp) do
    B.build_resource(:cluster_role)
    |> B.name("psp:rook")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{
        "apiGroups" => ["policy"],
        "resourceNames" => ["00-rook-privileged"],
        "resources" => ["podsecuritypolicies"],
        "verbs" => ["use"]
      }
    ])
  end

  resource(:cluster_role_rbd_csi_nodeplugin) do
    B.build_resource(:cluster_role)
    |> B.name("rbd-csi-nodeplugin")
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["secrets"], "verbs" => ["get", "list"]},
      %{"apiGroups" => [""], "resources" => ["nodes"], "verbs" => ["get", "list", "watch"]},
      %{"apiGroups" => [""], "resources" => ["namespaces"], "verbs" => ["get", "list"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumes"],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["volumeattachments"],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{"apiGroups" => [""], "resources" => ["configmaps"], "verbs" => ["get", "list"]},
      %{"apiGroups" => [""], "resources" => ["serviceaccounts"], "verbs" => ["get"]},
      %{"apiGroups" => [""], "resources" => ["serviceaccounts/token"], "verbs" => ["create"]}
    ])
  end

  resource(:cluster_role_rbd_external_provisioner_runner) do
    B.build_resource(:cluster_role)
    |> B.name("rbd-external-provisioner-runner")
    |> B.app_labels(@app)
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["secrets"], "verbs" => ["get", "list", "watch"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumes"],
        "verbs" => ["get", "list", "watch", "create", "delete", "update", "patch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumeclaims"],
        "verbs" => ["get", "list", "watch", "update"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["volumeattachments"],
        "verbs" => ["get", "list", "watch", "update", "patch"]
      },
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["volumeattachments/status"],
        "verbs" => ["patch"]
      },
      %{"apiGroups" => [""], "resources" => ["nodes"], "verbs" => ["get", "list", "watch"]},
      %{
        "apiGroups" => ["storage.k8s.io"],
        "resources" => ["storageclasses"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["events"],
        "verbs" => ["list", "watch", "create", "update", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshots"],
        "verbs" => ["get", "list", "watch", "update", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshotcontents"],
        "verbs" => ["create", "get", "list", "watch", "update", "delete", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshotclasses"],
        "verbs" => ["get", "list", "watch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshotcontents/status"],
        "verbs" => ["update", "patch"]
      },
      %{
        "apiGroups" => ["snapshot.storage.k8s.io"],
        "resources" => ["volumesnapshots/status"],
        "verbs" => ["update", "patch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumeclaims/status"],
        "verbs" => ["update", "patch"]
      },
      %{"apiGroups" => [""], "resources" => ["configmaps"], "verbs" => ["get"]},
      %{
        "apiGroups" => ["replication.storage.openshift.io"],
        "resources" => ["volumereplications", "volumereplicationclasses"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["replication.storage.openshift.io"],
        "resources" => ["volumereplications/finalizers"],
        "verbs" => ["update"]
      },
      %{
        "apiGroups" => ["replication.storage.openshift.io"],
        "resources" => ["volumereplications/status"],
        "verbs" => ["get", "patch", "update"]
      },
      %{
        "apiGroups" => ["replication.storage.openshift.io"],
        "resources" => ["volumereplicationclasses/status"],
        "verbs" => ["get"]
      },
      %{"apiGroups" => [""], "resources" => ["serviceaccounts"], "verbs" => ["get"]},
      %{"apiGroups" => [""], "resources" => ["serviceaccounts/token"], "verbs" => ["create"]}
    ])
  end

  resource(:config_map_ceph_operator, config) do
    namespace = Settings.public_namespace(config)

    data =
      %{}
      |> Map.put("CSI_CEPHFS_FSGROUPPOLICY", "ReadWriteOnceWithFSType")
      |> Map.put("CSI_ENABLE_CEPHFS_SNAPSHOTTER", "true")
      |> Map.put("CSI_ENABLE_CSIADDONS", "false")
      |> Map.put("CSI_ENABLE_ENCRYPTION", "false")
      |> Map.put("CSI_ENABLE_HOST_NETWORK", "true")
      |> Map.put("CSI_ENABLE_OMAP_GENERATOR", "false")
      |> Map.put("CSI_ENABLE_RBD_SNAPSHOTTER", "true")
      |> Map.put("CSI_ENABLE_VOLUME_REPLICATION", "false")
      |> Map.put("CSI_FORCE_CEPHFS_KERNEL_CLIENT", "true")
      |> Map.put("CSI_GRPC_TIMEOUT_SECONDS", "150")
      |> Map.put("CSI_NFS_FSGROUPPOLICY", "ReadWriteOnceWithFSType")
      |> Map.put("CSI_PLUGIN_ENABLE_SELINUX_HOST_MOUNT", "false")
      |> Map.put("CSI_PLUGIN_PRIORITY_CLASSNAME", "system-node-critical")
      |> Map.put("CSI_PROVISIONER_PRIORITY_CLASSNAME", "system-cluster-critical")
      |> Map.put("CSI_PROVISIONER_REPLICAS", "2")
      |> Map.put("CSI_RBD_FSGROUPPOLICY", "ReadWriteOnceWithFSType")
      |> Map.put("ROOK_CEPH_COMMANDS_TIMEOUT_SECONDS", "15")
      |> Map.put("ROOK_CSI_ENABLE_CEPHFS", "true")
      |> Map.put("ROOK_CSI_ENABLE_GRPC_METRICS", "false")
      |> Map.put("ROOK_CSI_ENABLE_NFS", "false")
      |> Map.put("ROOK_CSI_ENABLE_RBD", "true")
      |> Map.put("ROOK_LOG_LEVEL", "DEBUG")
      |> Map.put("ROOK_OBC_WATCH_OPERATOR_NAMESPACE", "true")
      |> Map.put("CSI_CEPHFS_PLUGIN_RESOURCE", get_resource(:csi_cephfs_plugin_resource))
      |> Map.put(
        "CSI_CEPHFS_PROVISIONER_RESOURCE",
        get_resource(:csi_cephfs_provisioner_resource)
      )
      |> Map.put("CSI_NFS_PLUGIN_RESOURCE", get_resource(:csi_nfs_plugin_resource))
      |> Map.put("CSI_NFS_PROVISIONER_RESOURCE", get_resource(:csi_nfs_provisioner_resource))
      |> Map.put("CSI_RBD_PLUGIN_RESOURCE", get_resource(:csi_rbd_plugin_resource))
      |> Map.put("CSI_RBD_PROVISIONER_RESOURCE", get_resource(:csi_rbd_provisioner_resource))

    B.build_resource(:config_map)
    |> B.name("rook-ceph-operator-config")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.data(data)
  end

  resource(:crd_cephblockpoolradosnamespaces_ceph_io) do
    yaml(get_resource(:cephblockpoolradosnamespaces_ceph_rook_io))
  end

  resource(:crd_cephblockpools_ceph_io) do
    yaml(get_resource(:cephblockpools_ceph_rook_io))
  end

  resource(:crd_cephbucketnotifications_ceph_io) do
    yaml(get_resource(:cephbucketnotifications_ceph_rook_io))
  end

  resource(:crd_cephbuckettopics_ceph_io) do
    yaml(get_resource(:cephbuckettopics_ceph_rook_io))
  end

  resource(:crd_cephclients_ceph_io) do
    yaml(get_resource(:cephclients_ceph_rook_io))
  end

  resource(:crd_cephclusters_ceph_io) do
    yaml(get_resource(:cephclusters_ceph_rook_io))
  end

  resource(:crd_cephfilesystemmirrors_ceph_io) do
    yaml(get_resource(:cephfilesystemmirrors_ceph_rook_io))
  end

  resource(:crd_cephfilesystems_ceph_io) do
    yaml(get_resource(:cephfilesystems_ceph_rook_io))
  end

  resource(:crd_cephfilesystemsubvolumegroups_ceph_io) do
    yaml(get_resource(:cephfilesystemsubvolumegroups_ceph_rook_io))
  end

  resource(:crd_cephnfses_ceph_io) do
    yaml(get_resource(:cephnfses_ceph_rook_io))
  end

  resource(:crd_cephobjectrealms_ceph_io) do
    yaml(get_resource(:cephobjectrealms_ceph_rook_io))
  end

  resource(:crd_cephobjectstores_ceph_io) do
    yaml(get_resource(:cephobjectstores_ceph_rook_io))
  end

  resource(:crd_cephobjectstoreusers_ceph_io) do
    yaml(get_resource(:cephobjectstoreusers_ceph_rook_io))
  end

  resource(:crd_cephobjectzonegroups_ceph_io) do
    yaml(get_resource(:cephobjectzonegroups_ceph_rook_io))
  end

  resource(:crd_cephobjectzones_ceph_io) do
    yaml(get_resource(:cephobjectzones_ceph_rook_io))
  end

  resource(:crd_cephrbdmirrors_ceph_io) do
    yaml(get_resource(:cephrbdmirrors_ceph_rook_io))
  end

  resource(:crd_objectbucketclaims_objectbucket_io) do
    yaml(get_resource(:objectbucketclaims_objectbucket_io))
  end

  resource(:crd_objectbuckets_objectbucket_io) do
    yaml(get_resource(:objectbuckets_objectbucket_io))
  end

  resource(:deployment_ceph_operator, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:deployment)
    |> B.name("rook-ceph-operator")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.spec(%{
      "replicas" => 1,
      "selector" => %{"matchLabels" => %{"app" => "rook-ceph-operator"}},
      "strategy" => %{"type" => "Recreate"},
      "template" => %{
        "metadata" => %{
          "labels" => %{
            "app" => "rook-ceph-operator",
            "battery/app" => "rook",
            "battery/managed" => "true"
          }
        },
        "spec" => %{
          "containers" => [
            %{
              "args" => ["ceph", "operator"],
              "env" => [
                %{"name" => "ROOK_CURRENT_NAMESPACE_ONLY", "value" => "false"},
                %{"name" => "ROOK_HOSTPATH_REQUIRES_PRIVILEGED", "value" => "false"},
                %{"name" => "ROOK_ENABLE_SELINUX_RELABELING", "value" => "true"},
                %{"name" => "ROOK_DISABLE_DEVICE_HOTPLUG", "value" => "false"},
                %{"name" => "ROOK_ENABLE_DISCOVERY_DAEMON", "value" => "false"},
                %{"name" => "ROOK_DISABLE_ADMISSION_CONTROLLER", "value" => "false"},
                %{
                  "name" => "NODE_NAME",
                  "valueFrom" => %{"fieldRef" => %{"fieldPath" => "spec.nodeName"}}
                },
                %{
                  "name" => "POD_NAME",
                  "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.name"}}
                },
                %{
                  "name" => "POD_NAMESPACE",
                  "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}
                }
              ],
              "image" => "rook/ceph:v1.9.9-6.g0d8fde8bd",
              "imagePullPolicy" => "IfNotPresent",
              "name" => "rook-ceph-operator",
              "ports" => [
                %{"containerPort" => 9443, "name" => "https-webhook", "protocol" => "TCP"}
              ],
              "resources" => %{
                "limits" => %{"cpu" => "500m", "memory" => "512Mi"},
                "requests" => %{"cpu" => "100m", "memory" => "128Mi"}
              },
              "securityContext" => %{
                "runAsGroup" => 2016,
                "runAsNonRoot" => true,
                "runAsUser" => 2016
              },
              "volumeMounts" => [
                %{"mountPath" => "/var/lib/rook", "name" => "rook-config"},
                %{"mountPath" => "/etc/ceph", "name" => "default-config-dir"},
                %{"mountPath" => "/etc/webhook", "name" => "webhook-cert"}
              ]
            }
          ],
          "serviceAccountName" => "rook-ceph-system",
          "volumes" => [
            %{"emptyDir" => %{}, "name" => "rook-config"},
            %{"emptyDir" => %{}, "name" => "default-config-dir"},
            %{"emptyDir" => %{}, "name" => "webhook-cert"}
          ]
        }
      }
    })
  end

  resource(:pod_security_policy_00_privileged) do
    B.build_resource(:pod_security_policy)
    |> B.name("00-rook-privileged")
    |> B.app_labels(@app)
    |> B.spec(%{
      "allowedCapabilities" => ["SYS_ADMIN", "MKNOD"],
      "fsGroup" => %{"rule" => "RunAsAny"},
      "hostIPC" => true,
      "hostNetwork" => true,
      "hostPID" => true,
      "hostPorts" => [
        %{"max" => 6790, "min" => 6789},
        %{"max" => 3300, "min" => 3300},
        %{"max" => 7300, "min" => 6800},
        %{"max" => 8443, "min" => 8443},
        %{"max" => 9283, "min" => 9283},
        %{"max" => 9070, "min" => 9070}
      ],
      "privileged" => true,
      "runAsUser" => %{"rule" => "RunAsAny"},
      "seLinux" => %{"rule" => "RunAsAny"},
      "supplementalGroups" => %{"rule" => "RunAsAny"},
      "volumes" => [
        "configMap",
        "downwardAPI",
        "emptyDir",
        "persistentVolumeClaim",
        "secret",
        "projected",
        "hostPath"
      ]
    })
  end

  resource(:role_binding_ceph_cluster_mgmt, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-cluster-mgmt")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-cluster-mgmt"))
    |> B.subject(B.build_service_account("rook-ceph-system", namespace))
  end

  resource(:role_binding_ceph_cmd_reporter, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-cmd-reporter")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("rook-ceph-cmd-reporter"))
    |> B.subject(B.build_service_account("rook-ceph-cmd-reporter", namespace))
  end

  resource(:role_binding_ceph_cmd_reporter_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-cmd-reporter-psp")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-ceph-cmd-reporter", namespace))
  end

  resource(:role_binding_ceph_default_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-default-psp")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("default", namespace))
  end

  resource(:role_binding_ceph_mgr, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-mgr")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("rook-ceph-mgr"))
    |> B.subject(B.build_service_account("rook-ceph-mgr", namespace))
  end

  resource(:role_binding_ceph_mgr_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-mgr-psp")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-ceph-mgr", namespace))
  end

  resource(:role_binding_ceph_mgr_system, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-mgr-system")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("rook-ceph-mgr-system"))
    |> B.subject(B.build_service_account("rook-ceph-mgr", namespace))
  end

  resource(:role_binding_ceph_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-osd")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("rook-ceph-osd"))
    |> B.subject(B.build_service_account("rook-ceph-osd", namespace))
  end

  resource(:role_binding_ceph_osd_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-osd-psp")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-ceph-osd", namespace))
  end

  resource(:role_binding_ceph_purge_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-purge-osd")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("rook-ceph-purge-osd"))
    |> B.subject(B.build_service_account("rook-ceph-purge-osd", namespace))
  end

  resource(:role_binding_ceph_purge_osd_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-purge-osd-psp")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-ceph-purge-osd", namespace))
  end

  resource(:role_binding_ceph_rgw, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-rgw")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("rook-ceph-rgw"))
    |> B.subject(B.build_service_account("rook-ceph-rgw", namespace))
  end

  resource(:role_binding_ceph_rgw_psp, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-rgw-psp")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_cluster_role_ref("psp:rook"))
    |> B.subject(B.build_service_account("rook-ceph-rgw", namespace))
  end

  resource(:role_binding_ceph_system, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rook-ceph-system")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.role_ref(B.build_role_ref("rook-ceph-system"))
    |> B.subject(B.build_service_account("rook-ceph-system", namespace))
  end

  resource(:role_binding_cephfs_csi_provisioner_cfg, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("cephfs-csi-provisioner-role-cfg")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("cephfs-external-provisioner-cfg"))
    |> B.subject(B.build_service_account("rook-csi-cephfs-provisioner-sa", namespace))
  end

  resource(:role_binding_rbd_csi_provisioner_cfg, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role_binding)
    |> B.name("rbd-csi-provisioner-role-cfg")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.role_ref(B.build_role_ref("rbd-external-provisioner-cfg"))
    |> B.subject(B.build_service_account("rook-csi-rbd-provisioner-sa", namespace))
  end

  resource(:role_ceph_cmd_reporter, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rook-ceph-cmd-reporter")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["pods", "configmaps"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      }
    ])
  end

  resource(:role_ceph_mgr, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rook-ceph-mgr")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["pods", "services", "pods/log"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["batch"],
        "resources" => ["jobs"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{"apiGroups" => ["ceph.rook.io"], "resources" => ["*"], "verbs" => ["*"]},
      %{
        "apiGroups" => ["apps"],
        "resources" => ["deployments/scale", "deployments"],
        "verbs" => ["patch", "delete"]
      },
      %{"apiGroups" => [""], "resources" => ["persistentvolumeclaims"], "verbs" => ["delete"]}
    ])
  end

  resource(:role_ceph_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rook-ceph-osd")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["secrets"], "verbs" => ["get"]},
      %{
        "apiGroups" => [""],
        "resources" => ["configmaps"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["ceph.rook.io"],
        "resources" => ["cephclusters", "cephclusters/finalizers"],
        "verbs" => ["get", "list", "create", "update", "delete"]
      }
    ])
  end

  resource(:role_ceph_purge_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rook-ceph-purge-osd")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([
      %{"apiGroups" => [""], "resources" => ["configmaps"], "verbs" => ["get"]},
      %{"apiGroups" => ["apps"], "resources" => ["deployments"], "verbs" => ["get", "delete"]},
      %{"apiGroups" => ["batch"], "resources" => ["jobs"], "verbs" => ["get", "list", "delete"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumeclaims"],
        "verbs" => ["get", "update", "delete", "list"]
      }
    ])
  end

  resource(:role_ceph_rgw, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rook-ceph-rgw")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([%{"apiGroups" => [""], "resources" => ["configmaps"], "verbs" => ["get"]}])
  end

  resource(:role_ceph_system, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rook-ceph-system")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["pods", "configmaps", "services"],
        "verbs" => ["get", "list", "watch", "patch", "create", "update", "delete"]
      },
      %{
        "apiGroups" => ["apps", "extensions"],
        "resources" => ["daemonsets", "statefulsets", "deployments"],
        "verbs" => ["get", "list", "watch", "create", "update", "delete"]
      },
      %{"apiGroups" => ["batch"], "resources" => ["cronjobs"], "verbs" => ["delete"]},
      %{
        "apiGroups" => ["cert-manager.io"],
        "resources" => ["certificates", "issuers"],
        "verbs" => ["get", "create", "delete"]
      }
    ])
  end

  resource(:role_cephfs_external_provisioner_cfg, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("cephfs-external-provisioner-cfg")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["endpoints"],
        "verbs" => ["get", "watch", "list", "delete", "update", "create"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["configmaps"],
        "verbs" => ["get", "list", "create", "delete"]
      },
      %{
        "apiGroups" => ["coordination.k8s.io"],
        "resources" => ["leases"],
        "verbs" => ["get", "watch", "list", "delete", "update", "create"]
      }
    ])
  end

  resource(:role_rbd_external_provisioner_cfg, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:role)
    |> B.name("rbd-external-provisioner-cfg")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.rules([
      %{
        "apiGroups" => [""],
        "resources" => ["endpoints"],
        "verbs" => ["get", "watch", "list", "delete", "update", "create"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["configmaps"],
        "verbs" => ["get", "list", "watch", "create", "delete", "update"]
      },
      %{
        "apiGroups" => ["coordination.k8s.io"],
        "resources" => ["leases"],
        "verbs" => ["get", "watch", "list", "delete", "update", "create"]
      }
    ])
  end

  resource(:service_account_ceph_cmd_reporter, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-ceph-cmd-reporter")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
  end

  resource(:service_account_ceph_mgr, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-ceph-mgr")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
  end

  resource(:service_account_ceph_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-ceph-osd")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
  end

  resource(:service_account_ceph_purge_osd, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-ceph-purge-osd")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
  end

  resource(:service_account_ceph_rgw, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-ceph-rgw")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
  end

  resource(:service_account_ceph_system, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-ceph-system")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
    |> B.label("storage-backend", "ceph")
  end

  resource(:service_account_csi_cephfs_plugin_sa, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-csi-cephfs-plugin-sa")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
  end

  resource(:service_account_csi_cephfs_provisioner_sa, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-csi-cephfs-provisioner-sa")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
  end

  resource(:service_account_csi_rbd_plugin_sa, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-csi-rbd-plugin-sa")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
  end

  resource(:service_account_csi_rbd_provisioner_sa, config) do
    namespace = Settings.public_namespace(config)

    B.build_resource(:service_account)
    |> B.name("rook-csi-rbd-provisioner-sa")
    |> B.namespace(namespace)
    |> B.app_labels(@app)
  end
end
