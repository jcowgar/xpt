#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  
		End Function
	#tag EndEvent


	#tag Note, Name = Overview
		Xojo Project Tool
		============
		
		Xojo Project Tool (xpt) is a command line application that will perform various operations
		on your `.xojo_project` files including:
		
		* Sorting folders
		* Source code line counts
		* Comment to code percentage
		* Syncronize entries in multiple projects
		
		Example uses
		----------
		
		Sort all items in alphabetical order:
		 
		`$ xpt --sort=all myproject.xojo_project`
		
		Sort only the Models folder:
		
		`$ xpt --sort=Models myproject.xojo_project`
		
		Syncronize all "models" in multiple projects:
		
		`$ xpt --sync --folder=Models projectA/hello.xojo_project projectB/goodbye.xojo_project`
		
		Count the lines of source code:
		
		`$ xpt --count-loc myproject.xojo_project`
		
		Report on the comment to code ratio:
		
		`$ xpt --comment-to-loc myproject.xojo_project`
		
		Various options can take a `--verbose` flag to report more information. For example, the
		`--count-loc` option normally only reports the totals. If given the `--verbose` flag, it
		will display the lines of code for each source file.
		
	#tag EndNote


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
