module generator

import os

pub const (
	c_root_web            = '/run/media/junko/Second/Projects/[Website] Nora/web'
	c_root_chapter_source = os.join_path(c_root_web, 'source/chapters/')
	c_root_chapter_output = os.join_path(c_root_web, 'chapters/')
)
