fs = require 'fs'
option '-o', '--output [dir]', 'dir for compiled code'

task 'watch', 'watch current dir', (options) ->
    {spawn} = require 'child_process'
    args = ['-w','-c']
    if options.output
        args = args.concat ['./']

        process.chdir __originalDirname
        coffee = spawn 'coffee', args
        coffee.stderr.on 'data', (data) ->
            process.stderr.write data.toString()
        coffee.stdout.on 'data', (data) ->
            console.log data.toString()

source = [
  '16col/imgtxtmode.coffee',
  '16col/ansi.coffee',  
  '16col/bin.coffee',
  '16col/idf.coffee',
  '16col/adf.coffee',
  '16col/sauce.coffee',
  '16col/tundra.coffee',
  '16col/pcboard.coffee',
  '16col/avatar.coffee',
  '16col/xbin.coffee',
  '16col/pallette.coffee',
  '16col/fonts.coffee',
]

task 'build', 'Build merged file for production', (options) ->
    {exec} = require 'child_process'
    content = []
    
    for file, index in source then do (file, index) ->
        fs.readFile file, 'utf8', (err, fileContents) ->
            throw err if err
            content[index] = fileContents
            if index == source.length - 1
                coffee = content.join('\n')
                fs.writeFile 'textmode.coffee', coffee, 'utf8', (err) ->
                    throw err if err
                    command = 'coffee --compile textmode.coffee'
                    exec command, (err, stdout, stderr) ->
                        throw err if err
                        console.log stdout + stderr