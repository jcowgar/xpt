#tag Class
Protected Class XManifest
	#tag Method, Flags = &h1
		Protected Sub Add(item as XManifestItem)
		  Child.Append item
		  
		  if item isa XManifestPathItem then
		    IdStore.Value(XManifestPathItem(item).Id) = item
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  IdStore = new Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Parse(fh as FolderItem)
		  //
		  // Construct a new XManifest from the contents of `fh`
		  //
		  
		  dim manifest as new XManifest
		  
		  dim tis as TextInputStream = TextInputStream.Open(fh)
		  
		  while not tis.EOF
		    dim line as String = tis.ReadLine.Trim
		    
		    //
		    // Get our Key and Value pair
		    //
		    
		    dim equalIdx as Integer = line.InStr("=")
		    dim key as String = line.Left(equalIdx - 1)
		    dim value as String = line.Mid(equalIdx + 1)
		    dim parts() as String = value.Split(";")
		    
		    //
		    // Decide what type of line we are looking at
		    //
		    
		    if line.InStr("Folder=") = 1 then
		      manifest.Add new XManifestFolder(key, parts)
		      
		    elseif line.InStr("Module=") = 1 then
		      manifest.Add new XManifestModule(key, parts)
		      
		    elseif line.InStr("Class=") = 1 then
		      manifest.Add new XManifestClass(key, parts)
		      
		    elseif line.InStr("Window=") = 1 then
		      manifest.Add new XManifestWindow(key, parts)
		      
		    else
		      //
		      // We are not terribly interested in this but we need to know if
		      // it is a nestable item or not, it may need to be sorted.
		      //
		      
		      if parts.Ubound = 4 then
		        manifest.Add new XManifestPathItem(key, parts)
		      else
		        manifest.Add new XManifestItem(key, value)
		      end if
		    end if
		  wend
		  
		  tis.Close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Child() As Xpt.XManifestItem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected IdStore As Dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Child()"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
	#tag EndViewBehavior
End Class
#tag EndClass
