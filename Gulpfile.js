/**
 * Standdown Gulpfile
 * Creates development environment & build process
 */

// Dependencies
// Note: Any plugin with the prefix 'gulp-' will be auto loaded
// to the $ namespace, using the gulp-load-plugins plugin
var gulp = require('gulp'),
		async = require('async'),
		del = require('del'),
		wiredep = require('wiredep').stream;

var $ = require('gulp-load-plugins')();

// Compiled assets for dev environment go here
var TMP_DIR = '.tmp';

/**
 * Cleanup TMP_DIR
 */
gulp.task('clean', function(cb) {
	del([TMP_DIR], cb);
});

/**
 * Process SASS Styles
 */
gulp.task('compile-styles', function() {
	return gulp.src('client/styles/main.scss')
		// Compile sass
		.pipe($.sass({
			errLogToConsole: true,
			sourceComments: 'map',
			imagePath: 'client/images'
		}))
		// Autoprefixer
		.pipe($.autoprefixer('last 1 version', '> 1%', 'ie 8', 'ie 7'))
		// Output to TMP_DIR
		.pipe(gulp.dest(TMP_DIR + '/styles'));
});

/**
 * Process Scripts
 */
gulp.task('compile-scripts', function() {
	return gulp.src('client/scripts/**/*.coffee')
		// Compile coffeescript with sourcemapping
		.pipe($.sourcemaps.init())
		.pipe($.coffee({ bare: true }).on('error', $.util.log))
		.pipe($.sourcemaps.write())
		// Process angular modules to be minification-safe
		.pipe($.ngAnnotate())
		// Output to TMP_DIR
		.pipe(gulp.dest(TMP_DIR));
});

/**
 * Compile Angular Views into JST
 */
gulp.task('compile-client-views', function() {
	return gulp.src('client/scripts/modules/**/*.html')
		.pipe($.html2js({
			base: 'client/scripts/modules',
			outputModuleName: 'standdown.templates'
		}))
		// Concatenate into templates.js
		.pipe($.concat('templates.js'))
		// Output to TMP_DIR
		.pipe(gulp.dest(TMP_DIR));
});

/**
 * Auto-inject all application scripts into index.html
 */
gulp.task('inject-scripts', ['compile-scripts', 'compile-client-views'], function() {
	return gulp.src('client/index.html')
		.pipe($.inject(gulp.src([TMP_DIR + '/**/*.js']), {
			read: false,
			ignorePath: TMP_DIR,
			addRootSlash: false
		}))
		// Output back into client/index.html
		.pipe(gulp.dest('client'));
});

/**
 * Auto-inject all Bower dependencies
 */
gulp.task('inject-bower', function() {
	return gulp.src('client/index.html')
		.pipe(wiredep({
			directory: 'client/vendor',
			overrides: {
				'semantic': {
					main: ['build/packaged/css/semantic.css', 'build/packaged/javascript/semantic.js']
				}
			},
			exclude: ['jeet.gs']
		}))
		// Output back into client/index.html
		.pipe(gulp.dest('client'));
});

/**
 * Start development server
 */
gulp.task('start-server', ['inject-bower', 'inject-scripts', 'compile-styles'], function() {
	return $.nodemon({ script: 'server/server.coffee', ext: 'json coffee', ignore: ['./client', './.tmp'] })
		.on('change', [/* Run tests eventually */])
		.on('restart', function() {
			console.log('Web server restarted.');
		});
});

/**
 * Setup watchers
 */
gulp.task('watch', function() {
	$.livereload.listen();

	// Recompile SASS on any changes
	gulp.watch(['client/styles/*.scss', 'client/scripts/modules/**/*.scss'], ['compile-styles']).on('change', $.livereload.changed);

	// Recompile .coffee on any changes
	// NOTE: If you add new .coffee file, server will need to be restarted
	gulp.watch(['client/scripts/**/*.coffee'], ['compile-scripts']).on('change', $.livereload.changed);

	// Recompile client views on any changes
	gulp.watch(['client/scripts/modules/**/*.html'], ['compile-client-views']).on('change', $.livereload.changed);

	// Reinject bower dependencies when new ones are added
	gulp.watch('bower.json', ['inject-bower']).on('change', $.livereload.changed);
});

/**
 * Start Development Environment (Default Task)
 */
gulp.task('dev', ['start-server', 'watch']);
gulp.task('default', ['dev']);