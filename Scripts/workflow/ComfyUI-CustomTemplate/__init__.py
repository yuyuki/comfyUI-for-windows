import logging
from comfy_env import register_nodes

log = logging.getLogger("ComfyUICustomTemplateModule")
log.info("loading...")

log.info("calling register_nodes")
NODE_CLASS_MAPPINGS, NODE_DISPLAY_NAME_MAPPINGS = register_nodes()

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS"]

log.info("Module loaded")
