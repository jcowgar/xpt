#tag Class
Protected Class XManifestSourceItem
Inherits Xpt.XManifestItem
	#tag Method, Flags = &h1000
		Sub Constructor(parentFh as FolderItem, key as String, parts() as String)
		  //
		  // Construct a new XManifestSourceItem
		  //
		  
		  Super.Constructor(key, parts)
		  
		  Self.File = GetRelativeFolderItem(Self.Path, parentFh)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GenerateStatistics(byref sourceCount as Integer, byref commentCount as Integer, printStatistics as Boolean, recurse as Boolean = True)
		  //
		  // Tally the code line and comment line counts.
		  //
		  // * Constants, Properties and Event Definitions are counted as 1 line
		  // * Method, Event, Getter and Setter lines are counted including function signature and end tag
		  // * Note bodies are counted as comments
		  //
		  
		  using Xpt
		  
		  //
		  // Generate statistics first for myself
		  //
		  
		  dim fileExtension as String = File.Extension_MTC
		  dim textExtensions() as String = Array("xojo_code", "xojo_window", "xojo_menu")
		  
		  if textExtensions.IndexOf(fileExtension) >= 0 then
		    GenerateStatisticsXojoCode
		  else
		    GenerateStatisticsXmlCode
		  end if
		  
		  sourceCount = sourceCount + CodeLineCount
		  commentCount = commentCount + CommentLineCount
		  
		  if printStatistics then
		    dim totalCount as Integer = CodeLineCount + CommentLineCount
		    dim commentPercent as Double = CommentLineCount / totalCount
		    dim commentPercentString as String = commentPercent.FormatPercent(True)
		    
		    dim codeLineCountString as String = CodeLineCount.FormatInteger
		    dim commentLineCountString as String = CommentLineCount.FormatInteger
		    dim totalCountString as String = totalCount.FormatInteger
		    
		    if CommentLineCount = 0 then
		      commentPercentString = "0%"
		    end if
		    
		    Print _
		    codeLineCountString.PadRight(7) + " | " + _
		    commentLineCountString.PadRight(7) + " | " + _
		    totalCountString.PadRight(7) + " | " + _
		    commentPercentString.PadRight(5) + " | " + _
		    ProjectPath
		  end if
		  
		  //
		  // Now make sure that each of my children items get their
		  // statistics included.
		  //
		  
		  if recurse then
		    for each item as XManifestItem in Self
		      item.GenerateStatistics(sourceCount, commentCount, printStatistics, recurse)
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GenerateStatisticsXmlCode()
		  //
		  // Read `xml_code` files generating statistics
		  //
		  
		  dim tis as TextInputStream = TextInputStream.Open(File)
		  
		  dim inProperty as Boolean
		  
		  while not tis.EOF
		    dim line as String = tis.ReadLine.Trim
		    
		    if line.InStr("<Property>") = 1 then
		      inProperty = True
		      
		      //
		      // Properties are weird in the XML file. The definition and comment is included
		      // as SourceLine tags. So, we know there will always be one line of code, so
		      // we will treat everything in a property as a comment but will add one
		      // to the code line count, and subtract one from the comment line count because
		      // the initial code line will be counted as a comment.
		      //
		      
		      CodeLineCount = CodeLineCount + 1
		      CommentLineCount = CommentLineCount - 1
		      
		    elseif line.InStr("</Property>") = 1 then
		      inProperty = False
		      
		    elseif inProperty and line.InStr("<SourceLine>") = 1 then
		      CommentLineCount = CommentLineCount + 1
		      
		    elseif line.InStr("<Enumeration>") = 1 then
		      //
		      // Add 1 code line for the enum definition. Each item in the
		      // enumeration will appear in their own SourceLine tag, so
		      // they will be counted already.
		      //
		      
		      CodeLineCount = CodeLineCount + 1
		      
		    elseif line.InStr("<Hook>") = 1 then
		      //
		      // Add 1 code line for each hook definition
		      //
		      
		      CodeLineCount = CodeLineCount + 1
		      
		    elseif line.InStr("<Constant>") = 1 then
		      CodeLineCount = CodeLineCount + 1
		      
		    elseif line.InStr("<SourceLine>//") = 1 _
		      or line.InStr("<SourceLine>'") = 1 _
		      or line.InStr("<NoteLine>") = 1 _
		      or line.InStr("<CodeDescription>") = 1 _
		      then
		      CommentLineCount = CommentLineCount + 1
		      
		    elseif line.InStr("<SourceLine>") = 1 then
		      CodeLineCount = CodeLineCount + 1
		    end if
		  wend
		  
		  tis.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GenerateStatisticsXojoCode()
		  //
		  // Read `xojo_code` files generating statistics
		  //
		  
		  dim tis as TextInputStream = TextInputStream.Open(File)
		  
		  dim inSourceCode as Boolean
		  dim inNote as Boolean
		  
		  while not tis.EOF
		    dim line as String = tis.ReadLine.Trim
		    
		    //
		    // Anything can have a description. If it does, it is good for
		    // one comment line.
		    //
		    
		    if line.InStr("#tag") = 1 and line.InStr("Description =") > 0 then
		      CommentLineCount = CommentLineCount + 1
		    end if
		    
		    if line.InStr("#tag Method") = 1 _
		      or line.InStr("#tag Event") = 1 _
		      or line.InStr("#tag Getter") = 1 _
		      or line.InStr("#tag Setter") = 1 _
		      then
		      inSourceCode = True
		      
		      //
		      // Account for this line being counted when it really should be
		      //
		      
		      CodeLineCount = CodeLineCount - 1
		      
		    elseif line.InStr("#tag Note") = 1 then
		      inNote = True
		      
		      //
		      // Account for this line being counted when it really should be
		      //
		      
		      CodeLineCount = CodeLineCount - 1
		      
		    elseif line.InStr("#tag End") = 1 then
		      inSourceCode = False
		      inNote = False
		      
		    elseif line.InStr("#tag Constant") = 1 then
		      CodeLineCount = CodeLineCount + 1
		      
		    elseif line.InStr("#tag Property") = 1 then
		      CodeLineCount = CodeLineCount + 1
		      
		    elseif line.InStr("#tag ComputedProperty") = 1 then
		      //
		      // Count an additional line for each computed property because there is a
		      // property signature. The code for the Getter and Setter are counted as
		      // CodeLine's in the "#tag Getter" and "#tag Setter" if condition.
		      //
		      
		      CodeLineCount = CodeLineCount + 1
		      
		    elseif line.InStr("Begin Menu") = 1 then
		      //
		      // 2 lines of code, typically the menu definition and setting the title
		      //
		      
		      CodeLineCount = CodeLineCount + 2
		    end if
		    
		    if inSourceCode then
		      if line.InStr("//") = 1 or line.InStr("'") = 1 then
		        CommentLineCount = CommentLineCount + 1
		      else
		        CodeLineCount = CodeLineCount + 1
		      end if
		      
		    elseif inNote then
		      CommentLineCount = CommentLineCount + 1
		    end if
		  wend
		  
		  tis.Close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CodeLineCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CommentLineCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		File As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="CodeLineCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CommentLineCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Id"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Key"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ParentId"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PathName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProjectPath"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UnknownOne"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
