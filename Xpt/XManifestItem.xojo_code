#tag Class
Protected Class XManifestItem
Inherits Xpt.XContainer
	#tag Method, Flags = &h0
		Sub Constructor(key as String, parts() as String)
		  //
		  // Create a new XManifestItem
		  //
		  
		  Self.Key = key
		  Self.Name = if(parts.Ubound >= 0, parts(0), "")
		  Self.Path = if(parts.Ubound >= 1, parts(1), "")
		  Self.Id = if(parts.Ubound >= 2, parts(2), "")
		  Self.ParentId = if(parts.Ubound >= 3, parts(3), "")
		  Self.UnknownOne = if(parts.Ubound >= 4, parts(4), "")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasId() As Boolean
		  return (Id <> "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasParentId() As Boolean
		  return (ParentId <> "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsContainer() As Boolean
		  return (Key = "Module" or Key = "Folder")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  dim result() as String
		  
		  //
		  // Build myself first
		  //
		  
		  dim parts() as String = Array(Name, Path, Id, ParentId, UnknownOne)
		  
		  for i as Integer = parts.Ubound downto 0
		    if parts(i) = "" then
		      parts.Remove i
		    else
		      exit for i
		    end if
		  next
		  
		  result.Append Key + "=" + Join(parts, ";")
		  
		  for i as Integer = 0 to Count - 1
		    result.Append Child(i).ToString
		  next
		  
		  return Join(result, EndOfLine)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Id As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Key As String
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //
			  // Get the name of this item based on it's path
			  //
			  
			  dim pathNoExtension as String = Path
			  dim equalIdx as Integer
			  
			  for i as Integer = Path.Len downto 1
			    if Path.Mid(i, 1) = "." then
			      equalIdx = i
			      
			      exit for i
			    end if
			  next
			  
			  if equalIdx > 0 then
			    pathNoExtension = Path.Left(equalIdx - 1)
			  end if
			  
			  return pathNoExtension
			End Get
		#tag EndGetter
		PathName As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		UnknownOne As String
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
			Name="Value"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
