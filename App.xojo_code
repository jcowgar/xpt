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
		  const kOptionCommentToLoc = "comment-to-loc"
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
		  parser.AddOption new Option("", kOptionCommentToLoc, "Report on the comment to line of code ration", Option.OptionType.Boolean)
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
		  dim commentToLoc as Boolean = parser.BooleanValue(kOptionCommentToLoc, False)
		  
		  Verbose = parser.BooleanValue(kOptionVerbose, False)
		  
		  if sort = "" and not sync and not countLoc and not commentToLoc then
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
		  
		  if sync then
		    //
		    // We should sync first as it may add or remove items
		    // that we would later want to sort or count
		    //
		    
		    NotImplemented(kOptionSync)
		  end if
		  
		  if sort <> "" then
		    //
		    // We should sort before counting if necessary so that
		    // any verbose output is displayed to the terminal in
		    // sorted order
		    //
		    
		    SortBy(sort)
		  end if
		  
		  //
		  // Finally we can report. This should occur last as it does not
		  // alter any project state
		  //
		  
		  if countLoc then
		    NotImplemented(kOptionCountLoc)
		  end if
		  
		  if commentToLoc then
		    NotImplemented(kOptionCommentToLoc)
		  end if
		  
		  Manifest.Save(fh)
		End Function
	#tag EndEvent


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
		Protected Sub SortBy(name as String)
		  using Xpt
		  
		  dim rootItem as XManifestItem = Manifest.FindByPathName(name)
		  if rootItem is nil then
		    Print "`" + name + "` is not a sortable item"
		    
		    Quit kErrorSort
		  end if
		  
		  dim names() as String
		  redim names(rootItem.Count - 1)
		  
		  for i as Integer = 0 to rootItem.Count - 1
		    dim item as XManifestItem = rootItem.Child(i)
		    names(i) = item.Name
		  next
		  
		  names.SortWith(rootItem.Children)
		End Sub
	#tag EndMethod


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
		
		Set versioning
		
		`$ xpt --version=1.2.3.4 myproject.xojo_project`
		
		Set any arbitary key/value pair
		
		`$ xpt --kv=WindowsName=xpt2.exe --kv=UseGDIPlus=True myproject.xojo_project`
		
		Various options can take a `--verbose` flag to report more information. For example, the
		`--count-loc` option normally only reports the totals. If given the `--verbose` flag, it
		will display the lines of code for each source file.
		
	#tag EndNote


	#tag Property, Flags = &h1
		Protected Manifest As Xpt.XManifest
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
