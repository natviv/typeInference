module HW6 where

import Prelude hiding (LT, GT, EQ, id)
import Data.Maybe
import Data.List

data BinaryOp = Add | Sub | Mul | Div | And | Or
              | GT | LT | LE | GE | EQ
  deriving (Eq, Show)

data UnaryOp = Neg | Not
  deriving (Eq, Show)

data Value = IntV  Int
           | BoolV Bool
           | ClosureV String Exp Env  -- new
  deriving (Eq)

instance Show Value where
	show (IntV n) = show n
	show (BoolV b) = show b
	show (ClosureV x b env) = "<Closure " ++ x ++ ">"

data Exp = Literal   Value
         | Unary     UnaryOp Exp
         | Binary    BinaryOp Exp Exp
         | If        Exp Exp Exp
         | Variable  String
         | Declare   String Exp Exp
         | Function  String Exp      -- new
         | Call      Exp Exp         -- changed
  deriving (Eq)
  
type Env = [(String, Value)]

{--
	Declaration of type Type
	Can be error,int,bool,
--}
data Type =  Error | Boolean | Intnum | Variable String | Function Type Type | Polymorphic [String] Type 
	deriving(Eq)

{--
	Making Type an instance of Show for printing	
--}
instance Show Type where
	show Error = "Expression has type error"
	show Boolean = "Bool"
	show Intnum = "Int"
	show (Variable x) = show x
	show (Function t1 t2) = "(" ++ show t1 ++ ")" ++ "->" ++ "("++ show t2 ++ ")"
	show Polymorphic freeVar t = "for every variable in "++show freeVar ++ "Expression has type "++show t  







-- Code to display expressions
instance Show Exp where
  show e = "[" ++ showExp 0 e ++ "]"

showExp level (Literal i)      = show i
showExp level (Variable x)    = x
showExp level (Declare x a b) = 
  if level > 0 then paren result else result
    where result = "let " ++ x ++ " = " ++ showExp 0 a ++ " in " ++ showExp 0 b
showExp level (If a b c)    = 
  if level > 0 then paren result else result
    where result = "if (" ++ showExp 0 a ++ ") " ++ showExp 0 b ++ "; else " ++ showExp 0 c
showExp level (Unary Neg a)    = "-" ++ showExp 99 a
showExp level (Unary Not a)    = "!" ++ showExp 99 a
showExp level (Binary op a b)  = showBinary level (fromJust (lookup op levels)) a (fromJust (lookup op names)) b
  where levels = [(Or, 1), (And, 2), (GT, 3), (LT, 3), (LE, 3), (GE, 3), (EQ, 3), 
                  (Add, 4), (Sub, 4), (Mul, 5), (Div, 5)] 
        names = [(Or, "||"), (And, "&&"), (GT, ">"), (LT, "<"), (LE, "<="), (GE, ">="), (EQ, "=="), 
                  (Add, "+"), (Sub, "-"), (Mul, "*"), (Div, "/")] 
showExp level (Function x body)    = "fun(" ++ x ++ ") " ++ showExp 0 body
showExp level (Call fun arg)    = 
	paren (showExp 6 fun ++ " " ++ showExp 6 arg)

showBinary outer inner a op b =
  if inner < outer then paren result else result
      where result = showExp inner a ++ " " ++ op ++ " " ++ showExp inner b
      
paren x = "(" ++ x ++ ")"
