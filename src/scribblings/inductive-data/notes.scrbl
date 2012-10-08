





@emph{Type:}

  binary tree
   @itemlist[@item{name: bt?}]

@emph{Subtypes:}

   empty tree:
   @itemlist[
    @item{name: ebt?}
    @item{constructor: ebt}
    @item{components: -}
    @item{extractors: -}
   ]
  
   nonempty tree: has 3 components
  
   @itemlist[
    @item{name: nbt?}
    @item{constructor: nbt
    
	constructor signature: 
	nbt : [symbol? bt? bt?] -> nbt?        
    }
    @item{components:
      @itemlist[
      @item{head: symbol?}
      @item{left: bt?}
      @item{right: bt?}
      ]}
   ]

@emph{Extractors:}
     @itemlist[
     @item{nbt-head: nbt? ->  symbol?}
     @item{nbt-left:  nbt? ->  bt?}
     @item{nbt-right:  nbt? -> bt?}
   ]

@bold{@emph{Code:}}

@itemlist[#:style 'ordered
  @item{Name your inductive type.

     <inductive-type-id?>

     Here <inductive-type-id?> is a symbol.
  }
  @item{Identify base cases:

     Identify the names for base case(s) and their
     representations as scheme constant(s), typically as a
     number, or a symbol, or the empty list.  Make sure that the
     different bases cases all have distinct values.
  }
  @item{Create scheme definitions for base cases:

     <id> : <inductive-type-id>
     
	@racket[(define <id> <exp>)]

     Here, <id> is the name of the base case element and <exp>
     evaluates to a value which is the value of that element. 
     
     The comment refers to the fact that the base case element
     <id> has the type <inductive-type-id>
 }
 @item{Identify the inductive cases. 
	 
     For each inductive case, choose a name <cid>. Define its
     signature, the number and types of its argumetns and the
     return type.  The return type must be <inductive-type-id>.


      <cid>  : [<type1> ... ] -> <inductive-type-id>

     For each constructor <cid>, define a function of that same
     name <cid>.  The number of formals of <cid> should match
     the number of arguments in the signature. 

     @racketblock[
     (define <cid>
       (lambda (<id> ...)
         ...))
     ]
  }
] 

Example:  natural numbers.
Approach: We will construct representations of natural numbers
          that are lists.

     Example: For natural numbers, we identify 0 as the base case 
     
      @racket[(define z 'z)]



Problem: Provide a design for inductively building Binary Trees of symbols

   



    
     empty-btree: btree

@racketblock[
(define empty-btree 'empty)



(define (nonempty-btree sym left right)
  (list 'nonempty  sym left right))
]

@itemlist[#:style 'ordered
@item{Define the base case(s):

 @itemlist[#:style 'ordered
	 @item{How may base cases?

	       Ans: One}

	 @item{}  
]
}

]


 * Arithmetic expressions consisting of numbers, and the
   operators +, and -.
