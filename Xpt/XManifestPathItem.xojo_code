#tag Class
Protected Class XManifestPathItem
Inherits Xpt.XManifestItem
	#tag Method, Flags = &h1000
		Sub Constructor(key as String, parts() as String)
		  //
		  
		  Super.Constructor(key, Join(parts, ";"))
		  
		  Self.Name = parts(0)
		  Self.Path = parts(1)
		  Self.Id = parts(2)
		  Self.ParentId = parts(3)
		  Self.UnknownOne = parts(4)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindByName(name as String) As Xpt.XManifestItem
		  //
		  // Loop through all items looking for an item named `name`
		  //
		  
		  for i as Integer = 0 to Child.Ubound
		    if Child(i) isa Xpt.XManifestPathItem then
		      dim item as Xpt.XManifestItem = Child(i)
		      
		      if item isa Xpt.XManifestPathItem then
		        dim pathItem as Xpt.XManifestPathItem = Xpt.XManifestPathItem(item)
		        if pathItem.Name = name then
		          return pathItem
		        end if
		        
		        item = pathItem.FindByName(name)
		        if not (item is nil) then
		          return item
		        end if
		      end if
		    end if
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  //
		  
		  dim result() as String
		  
		  //
		  // Convert myself first
		  //
		  
		  dim values() as String = Array(Name, Path, Id, ParentId, UnknownOne)
		  result.Append Key + "=" + Join(values, ";")
		  
		  //
		  // Convert all my children
		  //
		  
		  for i as Integer = 0 to Child.Ubound
		    result.Append Child(i).ToString
		  next
		  
		  return Join(result, EndOfLine)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Child() As Xpt.XManifestItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Id As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ParentId As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Path As String
	#tag EndProperty

	#tag Property, Flags = &h0
		UnknownOne As String
	#tag EndProperty


	#tag ViewBehavior
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
		#tag ViewProperty
			Name="Value"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
