require 'set'
class CasesController < ApplicationController
  before_action :authenticate_user!
  # before_action :admin_only, :except => :show


  def index
    if current_user.admin?
    @myCases = Case.all
    else
      @myCases = current_user.cases
    end

  end

  def claim
    p params[:id]
    @currentNode = $allNodeMap[params[:id]]
    # p @currentNode
    # p @currentNode.cNodes
  end

  def claimHypo
    p params[:id]
    @currentNode = $allNodeMap_hypo[params[:id]]
    # p @currentNode
    # p @currentNode.cNodes
  end

  def show





    @case = Case.find(params[:id])
    @pres = Pre.all




    $allNodeList = []
    @hasDims = @case.hasDims



    #新建根节点 rootnode, 并给rootnode的dims赋值,即输入case的dimension
    @rootNode = Node.new
    @rootNode.nDims = @hasDims

    #caselist存放要比较分析的case和dimension的交集数量,用于最后排序
    @caseList = Hash.new

    #找出所有remarkable case,然后遍历,每个case都要取dimension交集,获得他的数量,然后insert到claim lattice里
    @rootNode.set_totalNum_zero


    @nodeList=[]
    @allRemarkableCases = Case.where(kind: 1)
    @allRemarkableCases.each do |cAse|
      @oriSet = @rootNode.nDims
      @compSet = cAse.hasDims.to_set

      p "判断交集",cAse

      #如果交集不为空,则插入claim lattice, 并获取交集数量,排序
      if (@compSet & @oriSet).empty? == false

        p "有交集",cAse

        #初始化新node
        @newNode = Node.new

        #把要比较的case放入新node
        @newNode.nCases<<cAse

        #新node的dimension就是两个case的交集
        @newNode.nDims = cAse.hasDims & @rootNode.nDims

        # p "传入函数前 newNode",@newNode,@newNode.cNodes
        #插入这个case
        @rootNode.insert_case!(@newNode)
        # p "传入函数后 newNode",@newNode,@newNode.cNodes
        @nodeList<<@newNode

        #caselist存放要比较分析的case和dimension的交集数量,用于最后排序
        @caseList[cAse] = (@compSet & @oriSet).size

        end
      end

    #如果list有输入case自己,把自己删掉
    @caseList.delete(@case)
    # p 'rootnode children : ',@rootNode.cNodes.size,@rootNode.cNodes
    # p 'rootnode cases :', @rootNode.nCases

    @myCases = @caseList.sort { |a, b|  b[1]<=>a[1]}
    p 'caseList  :',@caseList



    @rootNode.set_totalNum_zero
    @rootNode.totalNum_add
    @rootNode.nodeNum = 1

    $allNodeList<<@rootNode
    getAllNode(@rootNode)

    # p "all node list",$allNodeList

    $allNodeMap = Hash.new
    $allNodeList.each do |node|
      # puts node
      # p "   name: ",node.nodeNum
      # p "   cnodes:",node.cNodes
      # p "cases:", node.nCases
      $allNodeMap[node.nodeNum.to_s] = node
    end

    p $allNodeMap
    # p "nodeList",@nodeList
    # @nodeList.each do |node|
    #   p "name: ",node.nodeNum
    #   p "cnodes:",node.cNodes
    #
    # end

    # @serialized_rootNode = Marshal.dump(@rootNode)
    # p Marshal.load(@serialized_rootNode).class
    # p @serialized_rootNode.size
    # unless current_user.admin?
    #   redirect_to :back, :alert => "Access denied. this is only for admin"
    # end



    #计算nearmiss dimension

    @hasPres = @case.pres
    p "case pres :",@hasPres

    @addFocal = []

    @nearMissDims = []
    Dim.all.each do |dim|
      if dim.focals[0]
        p "dim:",dim
        p "focals :",dim.focals[0].id,dim.focals[0].content
        @withoutFocal = []
        @presOfDim = dim.pres
        p "focals :",dim.focals
        @presOfDim.each do |pre|
          if pre.id != dim.focals[0].id
            @withoutFocal<<pre
            p "   insert pre:",pre
          end
        end
        if !((@hasPres & @presOfDim).empty?) && (@hasPres & @presOfDim != @presOfDim) && (@hasPres & @withoutFocal == @withoutFocal)
          p "has && pre",(@hasPres & @presOfDim).empty?
          @nearMissDims << dim
          @addFocal << dim.focals[0]
        end
      end
    end



    $allNodeList_hypo = []
    @hasDims_hypo = []

    #插入原本的dims
    @case.hasDims.each do |dim|
      @hasDims_hypo<< dim
    end

    #加入nearmiss dims
    @nearMissDims.each do |dim|
      @hasDims_hypo<< dim
    end



    #新建根节点 rootnode, 并给rootnode的dims赋值,即输入case的dimension
    @rootNode_hypo = Node.new
    @rootNode_hypo.nDims = @hasDims_hypo

    #caselist存放要比较分析的case和dimension的交集数量,用于最后排序
    @caseList_hypo = Hash.new

    #找出所有remarkable case,然后遍历,每个case都要取dimension交集,获得他的数量,然后insert到claim lattice里
    @rootNode_hypo.set_totalNum_zero


    @nodeList_hypo=[]
    @allRemarkableCases = Case.where(kind: 1)
    @allRemarkableCases.each do |cAse|
      @oriSet = @rootNode_hypo.nDims
      @compSet = cAse.hasDims.to_set

      p "判断交集",cAse

      #如果交集不为空,则插入claim lattice, 并获取交集数量,排序
      if (@compSet & @oriSet).empty? == false

        p "有交集",cAse

        #初始化新node
        @newNode_hypo = Node.new

        #把要比较的case放入新node
        @newNode_hypo.nCases<<cAse

        #新node的dimension就是两个case的交集
        @newNode_hypo.nDims = cAse.hasDims & @rootNode_hypo.nDims

        # p "传入函数前 newNode",@newNode,@newNode.cNodes
        #插入这个case
        @rootNode_hypo.insert_case!(@newNode_hypo)
        # p "传入函数后 newNode",@newNode,@newNode.cNodes
        @nodeList_hypo<<@newNode_hypo

        #caselist存放要比较分析的case和dimension的交集数量,用于最后排序
        @caseList_hypo[cAse] = (@compSet & @oriSet).size

      end
    end

    #如果list有输入case自己,把自己删掉
    @caseList_hypo.delete(@case)
    # p 'rootnode children : ',@rootNode.cNodes.size,@rootNode.cNodes
    # p 'rootnode cases :', @rootNode.nCases

    @myCases_hypo = @caseList_hypo.sort { |a, b|  b[1]<=>a[1]}
    p 'caseList  :',@caseList_hypo


    @nearMissCase = @myCases_hypo - @myCases_hypo


    @rootNode_hypo.set_totalNum_zero
    @rootNode_hypo.totalNum_add
    @rootNode_hypo.nodeNum = 1

    $allNodeList_hypo<<@rootNode_hypo
    getAllNode_hypo(@rootNode_hypo)

    # p "all node list",$allNodeList

    $allNodeMap_hypo = Hash.new
    $allNodeList_hypo.each do |node|
      # puts node
      # p "   name: ",node.nodeNum
      # p "   cnodes:",node.cNodes
      # p "cases:", node.nCases
      $allNodeMap_hypo[node.nodeNum.to_s] = node
    end

    p $allNodeMap_hypo


  end


  def getAllNode(getNode)
    getNode.cNodes.each do |cnode|
      cnode.totalNum_add
      cnode.set_nodeNum
      $allNodeList<<cnode
      if cnode.cNodes
        getAllNode(cnode)
      end
    end
  end

  def getAllNode_hypo(getNode)
    getNode.cNodes.each do |cnode|
      cnode.totalNum_add
      cnode.set_nodeNum
      $allNodeList_hypo<<cnode
      if cnode.cNodes
        getAllNode_hypo(cnode)
      end
    end
  end



  class Node
    attr :nDims ,true
    attr :nCases ,true
    attr :cNodes ,true
    attr :pNode ,true
    attr :nodeNum ,true
    @@totalNum = 0

    def initialize
      @nDims = []
      @nCases = []
      @cNodes = []
      @pNode = nil
      @@totalNum += 1
      @nodeNum = @@totalNum
    end

    def set_totalNum_zero
      @@totalNum = 0
    end

    def totalNum_add
      @@totalNum +=1
    end

    def set_nodeNum
      @nodeNum = @@totalNum
    end

    def insert_case!(newnode)
      p 'begin compare', newnode


      #如果newnode和根节点的dimension集合相同,则直接把case添加到rootnode内
      if (newnode.nDims & self.nDims) == self.nDims
        # self.nCases<<newnode.nCases
        newnode.nCases.each do |tempCase|
          self.nCases<<tempCase
        end
        p 'if equal',newnode.nCases,self.nCases

      #如果newnode是根节点的dimension的子集,则开始比较newnode和rootnode的每一个子节点
      # elsif (self.nDims & newnode.nDims) == newnode.nDims

      else #则newnode是根节点的dimension的子集,则开始比较newnode和rootnode的每一个子节点
        #newroots列表存放要插入的子节点
        @newroots = []
        p 'elseif contain newnode'

        #hasSome作为判断是否有cnode属于newnode的标志
        @hasSome = 0

        self.cNodes.each do |cnode|

          #如果newnode > cnode,则cnode作为newnode的子节点
          if ((newnode.nDims & cnode.nDims) == cnode.nDims) && (newnode.nDims != cnode.nDims)

            #把cnode放到newnode的子节点
            newnode.cNodes<<cnode
            # cnode.pNode = newnode
            newnode.cNodes.each { |child| child.pNode = newnode }
            p 'insert child to newnode',newnode

            #把cnode从原来的根节点的子节点List中删除
            self.cNodes.delete(cnode)
            p 'delete child from root'

            @hasSome = @hasSome+1

          elsif((newnode.nDims & cnode.nDims) == newnode.nDims)  #如果newnode 是 cnode的子集(可能是真子集也可以不是), 那么把newnode插入到包含它的cnode中

            p '@newroots<<cnode'

            #先把包含newnode的cnode放到newroots列表里,到时候再一个一个插入
            @newroots<<cnode

          end
        end

        p 'newroots : ', @newroots
        p 'hasome  :', @hasSome

        #如果有一部分子节点属于newnode,则把他们插入newnode
        if @hasSome > 0
          p 'hasSome > 0  self.cNodes<<newnode'

          self.cNodes<<newnode
          # newnode.pNode = self
          self.cNodes.each { |child| child.pNode = self }
          p "self",self
          p "newnode.pNode ",newnode.pNode

          #否则的话,如果没有子节点包含newnode,则newnode作为rootnode一个子节点
        else
          p "hasSome = 0"
          p @newroots
          if @newroots.empty?
            self.cNodes<<newnode
            # newnode.pNode = self
            self.cNodes.each { |child| child.pNode = self }
            p "self",self
            p "newnode.pNode ",newnode.pNode
          end
        end

        #如果有包含newnode的子节点,分别把newnode插入他们
        @newroots.each do |root|
          root.insert_case!(newnode)
        end

      # else
      #   p 'else'
      #   @newroots = []
      #   self.cNodes.each do |cnode|
      #     if ((newnode.nDims.contain & cnode.nDims) == cnode.nDims) && (newnode.nDims != cnode.nDims)
      #
      #       newnode.cNodes<<cnode
      #       cnode.pNode=newnode
      #
      #     else
      #       @newroots<<cnode
      #     end
      #   end
      #
      #   @newroots.each do |root|
      #     root.insert_case!(newnode)
      #   end
      end
      # return rootnode
    end
  end

  def new
    @case = Case.new()
    @pres = Pre.all
  end

  def create
    @case = Case.new()
    @case.title = params[:case][:title]
    # @case.kind = params[:case][:kind]
    @case.conclusion = params[:case][:conclusion]
    @case.user = current_user
    Pre.all.each do |pre|
      if params[pre.id.to_s]
        @case.pres<<pre
      end
    end
    @case.save
    redirect_to cases_path, :notice => "Case created."
  end

  def update
    @case = Case.find(params[:id])
    if current_user.admin?
      @case.kind = params[:case][:kind]
    end
    @allPres = Pre.all
    @case.pres.delete(@allPres)
    @allPres.each do |pre|
      if params[pre.id.to_s]
        @case.pres<<pre
      end
    end

    @case.save


    redirect_to cases_path, :notice => "Case updated."


  end

  def destroy
    myCase = Case.find(params[:id])
    myCase.destroy
    redirect_to cases_path, :notice => "Case deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied, This is only for administrators."
    end
  end

  def secure_params
    params.require(:case).permit(:kind)
  end
end
