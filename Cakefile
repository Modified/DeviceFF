### DeviceFF's Cakefile ###

fs=require 'fs'
{spawn,exec}=require 'child_process'
require 'colors'
#???... jsmin, uglify, packer, newer, watch…

# Tasks.
###???
task 'start','Build and run local web server',->build ->launch 'http-server',['--cors'] #??? watch instead of build!
task 'run','Just run web server (don\'t rebuild)',->launch 'http-server',['--cors']
###
task 'build','Compile/preprocess CS/Stylus, etc',->build ->console.log ':-)'.green
#??? task 'dist','Build into ./dist for distribution to production',->
#??? task 'watch','Continuously compile/preprocess CS/Stylus',->watch

# Build all client side assets: CoffeeScript, Stylus… #??? Add linting for all, and uglify, combine.
build=(next)-> #??? Build all environments at once!?
	console.log 'Building for',process.env.NODE_ENV?.blue
	#??? if typeof watch is 'function' then next=watch;watch=false
	#??? build_styl watch,->build_cs watch,next
	#??? build_cs ->
	build_styl ->build_teacup next
	#??? Inline CSS after compiling Teacup, using awk/file I/O and regexp, unless can make Stylus work within Teacup.
# Compile CoffeeScript into JavaScript.
build_cs=(next)-> #??? (watch,next)->
	#??? if typeof watch is 'function' then next=watch;watch=false
	options=['--compile'] #??? ,'--map'] Disabled because serves wrong URL! #??? Map only in development?
	if 'production' is process.env.NODE_ENV then options=options.concat ['--output','./dist']
	options=options.concat [
		'?.coffee' #???... et al! And combine! #??? Globbing doesn't work with spawn.
		]
	#??? options.unshift '--watch' if watch #???!!! Does not daemonize, doesn't exit!
	launch 'coffee',options,next
# Preprocess Stylus into CSS.
build_styl=(next)->
	#??? if typeof watch is 'function' then next=watch;watch=false
	options=['--compress'] #??? Map only in development? ,'--firebug' produces tons of junk!
	if 'production' is process.env.NODE_ENV then options=options.concat ['--out','./dist']
	options=options.concat [
		'device-mockup.styl'
		]
	#??? options.unshift '--watch' if watch #???!!! Does not daemonize, doesn't exit!
	launch 'stylus',options,next
# Generate HTML from Teacup templates.
build_teacup=(next)->
	cmd='for f in *.html.coffee; do coffee -e "console.log (require \'./$f\')()" > ${f%%.coffee}; done' #??? UGLY hack!? # "./" for require to include cwd. #??? Errors shown, but can't tell which file. "for" return code uninteresting -- how to test "require" succeeded?!
	console.log 'exec'.cyan,cmd
	#??? options=[]
	exec cmd,(err,stdout,stderr)-> #??? DRY
		unless err then next() else console.log {err,stdout,stderr};console.log ':-('.red.inverse
# Run process, not in shell. #??? exec instead?
launch=(cmd,options=[],next)->
	console.log 'spawn'.cyan,cmd,options,'...'
	app=spawn cmd,options
	app.stdout.pipe process.stdout
	app.stderr.pipe process.stderr
	app.on 'exit',(status)->
		if status is 0 then next() #??? Must exist?
		else console.log 'Error:'.red.inverse+" exit code #{status} from #{cmd}"
		#??? else process.exit status #???!!! Don't, let caller decide! No, they'll always do the same; DRY.
# Run in a shell???...
run=(cmd,next)-> #??? Use promises instead, so caller decides how to continue?
	console.log 'run'.cyan,cmd,'...'
