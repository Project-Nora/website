module generator

import os

pub const (
	c_latest_spec_format = 1
)

pub struct Chapter {
mut:
	version int
pub mut:
	// Metadata
	id          int    [ID]
	number      int    [Chapter]
	name        string [ChapterName]
	subject     string [ChapterSubject]
	episode     int    [Episode]
	title       string [Title]
	short_title string [ShortTitle]
	characters  string [Characters]
	author      string [Author]
	tags        string [Tags]
	date        string [Date]
	header      string [HeaderImage]
	// HTML
	html         string
	next_chapter &Chapter = unsafe { nil }
}

// Parse
pub fn Chapter.parse(path string) Chapter {
	mut chp := Chapter{}

	// Parse the shit
	mut lines := os.read_lines(path) or { panic(err) }
	mut metadata := [][]string{}
	mut html := []string{}

	for line in lines {
		// Version
		if line.starts_with('[') {
			chp.version = line.split('-')[1].int()
			continue
		}

		// Meta
		if line.starts_with('#') {
			metadata << line.split_nth('#', 2)[1].split(':').map(it.trim_space())
			continue
		}

		// Raw html
		html << line
	}

	chp.html = html.join('\n')

	// Parse the metadata
	// V's super cool feature
	$for field in Chapter.fields {
		// Loop thru all the metadata and see if we find any matching
		for meta in metadata {
			if field.attrs.len > 0 && meta[0] == field.attrs[0] {
				$if field.typ is string {
					chp.$(field.name) = meta[1]
				} $else $if field.typ is int {
					chp.$(field.name) = meta[1].int()
				} $else {
					println('shit')
				}
			}
		}
	}
	return chp
}

// Generate/Export
pub fn (chapter Chapter) export() string {
	return $tmpl('templates/chapter.html')
}

pub fn get_chapters() []Chapter {
	mut chapters := []Chapter{}

	for file in os.glob(os.join_path(c_root_chapter_source, '*.html')) or { [] } {
		chapters << Chapter.parse(file)
	}

	for i := 0; i < chapters.len; i++ {
		if i + 1 < chapters.len && chapters[i].id == chapters[i + 1].id - 1 {
			chapters[i].next_chapter = unsafe { &chapters[i + 1] }
		}
	}

	return chapters
}
