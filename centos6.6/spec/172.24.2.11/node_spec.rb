require 'spec_helper'



describe command("node --version"), node:true do

  its(:stdout) { should contain($config['node_version']) }

end
#  describe command("node -V") do
#    its(:stdout) {should_not  contain("-bash")}#si contiene -bash  es porque no se ha abierto node, por tanto no esta instalado..
#  end
