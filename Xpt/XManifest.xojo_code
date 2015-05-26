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
		Function FindByName(name as String) As Xpt.XManifestItem()
		  //
		  // Loop through all items looking for an item named `name`
		  //
		  
		  dim result() as Xpt.XManifestItem
		  
		  for i as Integer = 0 to Child.Ubound
		    if Child(i) isa Xpt.XManifestPathItem then
		      dim pathItem as Xpt.XManifestPathItem = Xpt.XManifestPathItem(Child(i))
		      if pathItem.Name = name then
		        result.Append pathItem
		      end if
		      
		      dim item as Xpt.XManifestItem = pathItem.FindByName(name)
		      if not (item is nil) then
		        result.Append item
		      end if
		    end if
		  next
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Parse(fh as FolderItem) As Xpt.XManifest
		  //
		  // Construct a new XManifest from the contents of `fh`
		  //
		  
		  dim manifest as new Xpt.XManifest
		  
		  //
		  // Parse the manifest file
		  //
		  
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
		  
		  //
		  // Nest items that can be nested
		  //
		  
		  for i as Integer = manifest.Child.Ubound downto 0
		    dim item as Xpt.XManifestItem = manifest.Child(i)
		    
		    select case item
		    case isa XManifestPathItem
		      dim pathItem as Xpt.XManifestPathItem = Xpt.XManifestPathItem(item)
		      dim parentItem as Xpt.XManifestPathItem = manifest.IdStore.Lookup(pathItem.ParentId, nil)
		      
		      if parentItem is nil then
		        continue
		      end if
		      
		      parentItem.Child.Append pathItem
		      
		      manifest.Child.Remove i
		    end select
		  next
		  
		  return manifest
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save(fh as FolderItem)
		  for i as Integer = 0 to Child.Ubound
		    Print Child(i).ToString
		  next
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
