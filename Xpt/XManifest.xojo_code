#tag Class
Protected Class XManifest
Inherits Xpt.XContainer
	#tag Method, Flags = &h1
		Protected Sub Add(item as Xpt.XManifestItem)
		  //
		  // Add an item to the manifest.
		  //
		  
		  Super.Add(item)
		  
		  //
		  // We need to be able to lookup quickly an item by it's Id, so
		  // let's store a reference of the item by Id, but only if it
		  // has an Id.
		  //
		  
		  if item.HasId then
		    IdLookup.Value(item.Id) = item
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(fh as FolderItem)
		  Self.SourceFile = fh
		  
		  IdLookup = new Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function File() As FolderItem
		  return SourceFile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Parse(fh as FolderItem) As Xpt.XManifest
		  //
		  // Construct a new XManifest from the contents of `fh`
		  //
		  
		  using Xpt
		  
		  dim manifest as new XManifest(fh)
		  dim manifestParentFolderItem as FolderItem = fh.Parent
		  
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
		      manifest.Add new XManifestModule(manifestParentFolderItem, key, parts)
		      
		    elseif line.InStr("Class=") = 1 then
		      manifest.Add new XManifestClass(manifestParentFolderItem, key, parts)
		      
		    elseif line.InStr("Interface=") = 1 then
		      manifest.Add new XManifestInterface(manifestParentFolderItem, key, parts)
		      
		    elseif line.InStr("Window=") = 1 then
		      manifest.Add new XManifestWindow(manifestParentFolderItem, key, parts)
		      
		    else
		      manifest.Add new XManifestItem(key, parts)
		    end if
		  wend
		  
		  tis.Close
		  
		  //
		  // Nest items that can be nested
		  //
		  
		  for i as Integer = manifest.Count - 1 downto 0
		    dim item as XManifestItem = manifest.Child(i)
		    
		    if item.HasParentId then
		      dim parentItem as XManifestItem = manifest.IdLookup.Lookup(item.ParentId, nil)
		      if parentItem is nil then
		        continue
		      end if
		      
		      parentItem.Add item
		      manifest.Children.Remove i
		    end if
		  next
		  
		  return manifest
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  //
		  // Save the manifest file to `fh`. If `fh` is `nil`, then the new Manifest
		  // is echoed to the screen instead
		  //
		  
		  dim tos as TextOutputStream = TextOutputStream.Create(SourceFile)
		  tos.Write ToString
		  tos.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  //
		  // Save the manifest file to `fh`. If `fh` is `nil`, then the new Manifest
		  // is echoed to the screen instead
		  //
		  
		  dim result() as String
		  for each item as Xpt.XManifestItem in Self
		    result.Append item.ToString
		  next
		  
		  return Join(result, EndOfLine)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected IdLookup As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected SourceFile As FolderItem
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
