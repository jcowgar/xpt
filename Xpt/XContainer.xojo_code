#tag Class
Protected Class XContainer
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
		Function FindByProjectPathName(projectPathName as String) As Xpt.XManifestItem
		  //
		  // Loop through all items looking for an item named `name`
		  //
		  
		  using Xpt
		  
		  //
		  // Loop through each child item
		  //
		  
		  for each item as XManifestItem in Children
		    //
		    // Item could be the one we are looking for
		    //
		    
		    if item.ProjectPathName = projectPathName then
		      return item
		    end if
		    
		    //
		    // Loop through each child of item checking it
		    //
		    
		    dim childItem as XManifestItem = item.FindByProjectPathName(projectPathName)
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


	#tag Property, Flags = &h0
		Children() As Xpt.XManifestItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Id"
			Group="Behavior"
			Type="String"
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
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Group="Behavior"
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
		#tag ViewProperty
			Name="UnknownOne"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
