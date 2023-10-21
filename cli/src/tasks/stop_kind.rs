use std::path::Path;

use crate::{install_bin::install_kind, kind::stop_cluster};
use eyre::Result;
use tracing::info;

const DEFAULT_CLUSTER_NAME: &str = "batteries";

pub async fn stop_kind_cluster(dir_parent: &Path, arch: &str) -> Result<()> {
    info!("Stopping kind cluster, {}", DEFAULT_CLUSTER_NAME);

    let kind_path = install_kind(dir_parent, arch).await?;
    stop_cluster(kind_path.as_path(), DEFAULT_CLUSTER_NAME)
}
