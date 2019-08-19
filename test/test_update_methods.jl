using ExtensibleUnions
using Test

function f1 end
ExtensibleUnions._update_all_methods_for_extensiblefunction!(f1)
