import logging
from typing import Dict

log = logging.getLogger("ComfyUICustomTemplateModule")
log.info("loading...")

NODE_CLASS_MAPPINGS: Dict[str, type] = {}
NODE_DISPLAY_NAME_MAPPINGS: Dict[str, str] = {}

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS"]

log.info("Module loaded")
