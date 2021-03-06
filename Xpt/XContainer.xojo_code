#tag Class
Protected Class XContainer
Implements xojo.Core.Iterable
	#tag Method, Flags = &h0
		Sub Add(item as Xpt.XManifestItem)
		  //
		  // Add an item to this container
		  //
		  
		  using Xpt
		  
		  if Self isa XManifestItem then
		    item.Parent = XManifestItem(Self)
		  end if
		  
		  Children.Append item
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(index as Integer) As Xpt.XManifestItem
		  return Children(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  return (Children.Ubound + 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindByProjectPath(ProjectPath as String) As Xpt.XManifestItem
		  //
		  // Loop through all items looking for an item named `name`
		  //
		  
		  using Xpt
		  
		  //
		  // Loop through each child item
		  //
		  
		  for each item as XManifestItem in Self
		    //
		    // Item could be the one we are looking for
		    //
		    
		    if item.ProjectPath = ProjectPath then
		      return item
		    end if
		    
		    //
		    // Loop through each child of item checking it
		    //
		    
		    dim childItem as XManifestItem = item.FindByProjectPath(ProjectPath)
		    if childItem isa XManifestItem then
		      return childItem
		    end if
		  next
		  
		  //
		  // Nothing found
		  //
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Gather(byref items() as Xpt.XManifestItem)
		  if Self isa Xpt.XManifestItem then
		    items.Append Xpt.XManifestItem(Self)
		  end if
		  
		  for each item as Xpt.XManifestItem in Self
		    item.Gather(items)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIterator() As xojo.Core.Iterator
		  return new Xpt.XContainerIterator(Children)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected Children() As Xpt.XManifestItem
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
