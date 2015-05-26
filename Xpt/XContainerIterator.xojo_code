#tag Class
Protected Class XContainerIterator
Implements xojo.Core.Iterator
	#tag Method, Flags = &h0
		Sub Constructor(children() as Xpt.XManifestItem)
		  CurrentIndex = -1
		  
		  Self.Children = children
		  Self.LastIndex = children.Ubound
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MoveNext() As Boolean
		  CurrentIndex = CurrentIndex + 1
		  
		  return CurrentIndex <= LastIndex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value() As Auto
		  return Children(CurrentIndex)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected Children() As Xpt.XManifestItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CurrentIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastIndex As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="CurrentIndex"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Group="Behavior"
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
