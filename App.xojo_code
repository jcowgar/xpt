#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  //
		  // Command line entry point for xpt
		  //
		  
		  const kOptionSort = "sort"
		  const kOptionSync = "sync"
		  const kOptionCountLoc = "count-loc"
		  const kOptionRecursive = "recursive"
		  const kOptionSimulate = "simulate"
		  const kOptionVerbose = "verbose"
		  
		  if args(0) = App.ExecutableFile.Name then
		    args.Remove 0
		  end if
		  
		  //
		  // Parse our command line options
		  //
		  
		  dim parser as new OptionParser
		  parser.ExtrasRequired = 1
		  
		  parser.AddOption new Option("", kOptionSort, "Sort items in the project (Folder/Module name or all)", Option.OptionType.String)
		  parser.AddOption new Option("", kOptionSync, "Synchronize items from various projects", Option.OptionType.Boolean)
		  parser.AddOption new Option("", kOptionCountLoc, "Count the number of lines of code", Option.OptionType.Boolean)
		  parser.AddOption new Option("", kOptionRecursive, "Perform the operation recursively", Option.OptionType.Boolean)
		  parser.AddOption new Option("", kOptionSimulate, "Display the resulting manifest instead of saving it to disk", Option.OptionType.Boolean)
		  parser.AddOption new Option("", kOptionVerbose, "Produce verbose output", Option.OptionType.Boolean)
		  parser.Parse(args)
		  
		  dim fh as FolderItem = GetRelativeFolderItem(parser.Extra(0))
		  if fh is nil or not fh.IsReadable or not fh.IsWriteable then
		    Print parser.Extra(0) + " is invalid, it must exist and be both readable and writeable."
		    parser.ShowHelp
		    Quit kErrorUsage
		  end if
		  
		  Print "Parsing manifest: " + fh.ShellPath
		  
		  dim sort as String = parser.StringValue(kOptionSort)
		  dim sync as Boolean = parser.BooleanValue(kOptionSync, False)
		  dim countLoc as Boolean = parser.BooleanValue(kOptionCountLoc, False)
		  
		  Recursive = parser.BooleanValue(kOptionRecursive, False)
		  Simulate = parser.BooleanValue(kOptionSimulate, False)
		  Verbose = parser.BooleanValue(kOptionVerbose, False)
		  
		  dim doSave as Boolean
		  
		  if sort = "" and not sync and not countLoc then
		    //
		    // The user did not select any operation
		    //
		    
		    Print "You did not select any operation to perform"
		    parser.ShowHelp
		    Quit kErrorUsage
		  end if
		  
		  //
		  // Parse the manifest file
		  //
		  
		  Manifest = Xpt.XManifest.Parse(fh)
		  
		  //
		  // Perform the operations in a logical order
		  //
		  
		  //
		  // We should sync first as it may add or remove items
		  // that we would later want to sort or count
		  //
		  
		  if sync then
		    NotImplemented(kOptionSync)
		  end if
		  
		  //
		  // We should sort before counting if necessary so that
		  // any verbose output is displayed to the terminal in
		  // sorted order
		  //
		  
		  if sort = "all" then
		    SortAll()
		    
		    doSave = True
		    
		  elseif sort <> "" then
		    SortBy(sort)
		    
		    doSave = True
		  end if
		  
		  //
		  // Finally we can report. This should occur last as it does not
		  // alter any project state
		  //
		  
		  if countLoc then
		    CountLines()
		  end if
		  
		  //
		  // Only save the manifest if user requested some change
		  //
		  
		  if doSave then
		    dim saveFh as FolderItem = if(Simulate, nil, fh)
		    
		    if not Simulate then
		      Print "Saving manifest: " + saveFh.Name
		    end if
		    
		    Manifest.Save(saveFh)
		  end if
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub CountLines()
		  using Xpt
		  
		  const kSep = "--------------------------------------------------"
		  
		  if Verbose then
		    dim codeLineHeader as String = "Code"
		    dim commentLineHeader as String = "Comment"
		    dim totalLineHeader as String = "Total"
		    dim commentPercentHeader as String = "C-C%"
		    dim fileHeader as String = "File"
		    
		    Print _
		    codeLineHeader.PadRight(7) + " | " + _
		    commentLineHeader.PadRight(7) + " | " + _
		    totalLineHeader.PadRight(7) + " | " + _
		    commentPercentHeader.PadRight(5) + " | " + _
		    fileHeader
		    Print kSep
		  end if
		  
		  dim sourceCount as Integer
		  dim commentCount as Integer
		  dim totalCount as Integer
		  dim commentPercent as Double
		  
		  for each item as XManifestItem in Manifest
		    item.GenerateStatistics(sourceCount, commentCount, Verbose)
		  next
		  
		  totalCount = sourceCount + commentCount
		  commentPercent = commentCount / totalCount
		  
		  dim commentPercentString as String = commentPercent.FormatPercent(True)
		  
		  if commentCount = 0 then
		    commentPercentString = "0%"
		  end if
		  
		  dim codeLineCountString as String = sourceCount.FormatInteger.PadRight(7)
		  dim commentLineCountString as String = commentCount.FormatInteger.PadRight(7)
		  dim totalCountString as String = totalCount.FormatInteger.PadRight(7)
		  
		  if Verbose then
		    Print kSep
		    
		    Print _
		    codeLineCountString + " | " + _
		    commentLineCountString + " | " + _
		    totalCountString + " | " + _
		    commentPercentString.PadRight(5) + " | " + _
		    "Total"
		    
		  else
		    Print " Source Line Count: " + codeLineCountString
		    Print "Comment Line Count: " + commentLineCountString
		    Print " Comment to Source: " + commentPercentString.PadRight(7)
		    Print "       Total Count: " + totalCountString
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub NotImplemented(key as String)
		  //
		  // Display an error message stating the option is not yet implemented
		  // and then quit with an exit code
		  //
		  
		  Print "The --" + key + " option is not yet implemented."
		  
		  Quit kErrorNotImplemented
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SortAll()
		  using Xpt
		  
		  for each item as XManifestItem in Manifest
		    if item.IsContainer then
		      Print "Sorting recursively: " + item.Name
		      
		      item.Sort(True)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SortBy(name as String)
		  using Xpt
		  
		  dim rootItem as XManifestItem = Manifest.FindByProjectPath(name)
		  if rootItem is nil then
		    Print "`" + name + "` is not a sortable item"
		    
		    Quit kErrorSort
		  end if
		  
		  Print "Sorting" + if(Recursive, " recursively", "") + ": " + rootItem.Name
		  
		  rootItem.Sort(Recursive)
		End Sub
	#tag EndMethod


	#tag Note, Name = Code to Comment Ratio
		An important ratio for your project is the Code to Comment
		ratio. This is the number of lines of code compared to the
		number of lines of comments.
		
		While there is no magical ratio, one should set a standard
		for your project and try to achieve that value. The Code
		to Comment ratio can be a health status of your project as
		well. Is my Code to Comment ratio going down as I code,
		remaining steady or increasing?
		
		All soruce code comments are counted. Note items are also
		counted as comments.
		
		This ratio could change in different releases of `xpt` as the
		method for counting lines of code may change affecting this
		calculation indirectly.
		
	#tag EndNote

	#tag Note, Name = Key/Value Pairs
		In the `xojo_project` files, there are many miscellaneous Key/Value
		pairs that one may wish to change. For example, to turn on Windows
		GDI Plus from the command line, you could:
		
		`$ xpt --kv=UseGDIPlus=True myproject.xojo_project`
		
	#tag EndNote

	#tag Note, Name = Lines of Code
		While not as important as it once use to be, knowing how
		many lines of code your project is can be useful and informative.
		This, however, is hard to determine with Xojo because the
		source files contain a lot of meta data.
		
		With `xpt` you can count the number of actual source lines.
		
		`$ xpt --count-loc myproject.xojo_project`
		
		will report on the actual code lines. We've tried to mimic
		what would be counted in other languages, such as the
		function signature. As time goes on, the actual method
		of counting the lines of code may change. For example,
		what should actually be counted on a Window? Ever method
		and event for sure but what about controls? X, Y, Width and
		Height? TabStop? etc...
		
	#tag EndNote

	#tag Note, Name = Overview
		Xojo Project Tool
		============
		
		Xojo Project Tool (xpt) is a command line application that will perform various operations
		on your `.xojo_project` files including:
		
		* Sorting folders
		* Source code line counts
		* Comment to code percentage
		* Syncronize entries in multiple projects
		* Update versioning
		* Setting arbitrary manifest values
		
	#tag EndNote

	#tag Note, Name = Sorting
		As projects grow and classes are added, folders and modules tend to get out of
		order. Order helps one find a class quickly in the project tree. xpt can help
		in this area by sorting Folders and Modules.
		
		xpt can sort just a given folder or module:
		
		`
		$ xpt --sort=Models myproject.xojo_project
		`
		
		The parameter to sort does not depend on physical path, but project path.
		For example, say you have a folder named `Models` and under that another
		folder named `Core.` If you wished to sort the `Core` models, you would:
		
		`
		$xpt --sort=Models/Core myproject.xojo_project
		`
		
		You can also sort all children in all Folders and Modules:
		
		`
		$ xpt --sort=all myproject.xojo_project
		`
		
	#tag EndNote

	#tag Note, Name = Synchronizing
		Some projects will share code. Continuing with our models example, say you have
		a command line program that performs various operations with your data and also
		a desktop application using the same models. It becomes cumbersome to maintain
		a models list in both applications.
		
		You can synchronize your models between the two projects. Synchronizing the models
		will take any entry in any project supplied that is a legitimate entry, i.e. the file
		exists and copy it to the other projects that do not have it. For example, say you
		add a new model to your console application named Person. Your desktop application
		does not yet have that model. In addition, someone else has done work in the
		desktop application adding a model named Child, but did not add it to the console
		application.
		
		`
		$ xpt --sync --folder=Models console/myproject.xojo_project desktop/myproject.xojo_project
		`
		
		will see that Person exists (and is valid) in the console application but not the
		desktop application. It will add an entry to the desktop application. Likewise, it will
		see that Child was added to the console application but does not exist in the Desktop
		application, thus adding an entry there.
		
		
	#tag EndNote

	#tag Note, Name = Verbosity
		Various options can take a `--verbose` flag to report more information. For example, the
		`--count-loc` option normally only reports the totals. If given the `--verbose` flag, it
		will display the lines of code for each source file.
		
	#tag EndNote

	#tag Note, Name = Versioning
		Many times in automated builds, it's nice to be able to set
		the versioning from a shell script. `--version` does exactly
		that.
		
		`$ xpt --version=1.2.3.4 myproject.xojo_project`
		
		sets Major = 1, Minor = 2, Bug = 3, Non-Release = 4
		
		You can also set the stage code:
		
		`$ xpt --stage-code=Development myproject.xojo_project`
		
		`--stage-code` can be:
		
		* Development
		* Alpha
		* Beta
		* Final 
	#tag EndNote


	#tag Property, Flags = &h1
		Protected Manifest As Xpt.XManifest
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Recursive As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Simulate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Verbose As Boolean
	#tag EndProperty


	#tag Constant, Name = kErrorNotImplemented, Type = Double, Dynamic = False, Default = \"254", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorSort, Type = Double, Dynamic = False, Default = \"253", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorUsage, Type = Double, Dynamic = False, Default = \"255", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
