module VirtualMachineMethods
  def open_class(class_name, superklass, scope)
    @classes[class_name] ||= RubyOnRun::VM::RClass.new(self, superklass)
  end

  def add_defn_method(method_name, compiled_code, scope, method_visibility)
    scope.define_method(method_name, compiled_code)
  end

  def attach_method(method_name, compiled_code, scope, _self)
    _self.add_singleton_method method_name, compiled_code
  end
end
