module generator

import os

pub fn create() {
	println('> Getting chapters!')

	mut chapters := get_chapters()

	println('> Generating chapters!')

	for chapter in chapters {
		filename := '${chapter.number}-${chapter.episode}.html'
		file_path := os.join_path(c_root_chapter_output, filename)

		// if !os.exists(file_path) {
		// TODO: Implement proper dupe checking.
		if true {
			os.write_file(file_path, chapter.export()) or { panic(err) }
		}
	}

	println('> Generating index!')
	index_path := os.join_path(c_root_web, 'index.html')
	os.write_file(index_path, $tmpl('templates/index.html')) or { panic(err) }
}
