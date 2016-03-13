//
//  CalculatorBrian.swift
//  Calculator
//
//  Created by Junor on 16/3/5.
//  Copyright © 2016年 Junor. All rights reserved.
//

import Foundation

class CalculatorBrain {

    private enum Op: CustomStringConvertible {
        case Variable(String)
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, (Double, Double) -> Double)
        
        var description: String {
            switch self {
            case .Variable(let variable):
                return variable
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _, _):
                return symbol
            }
        }
        
        var precedence: Int {
            get {
                switch self {
                case BinaryOperation(_, let precedence, _):
                    return precedence
                default: return Int.max
                }
            }
        }
        
    }
    
    private var opStack = [Op]()
    private var knowsOp = [String: Op]()
    
    var variableValues = [String: Double]()
    var formulaDescription = ""
    
    var description: String {
        get {
            let remainingStack = opStack
            var (desc, restOp1, _) = description(remainingStack)
            formulaDescription = desc  // will used in Graph
            while restOp1.count > 0 {
                let (resDes, restOp2, _) = description(restOp1)
                desc = resDes + " ," + desc
                restOp1 = restOp2
            }
            return desc + " ="
        }
    }
    
    var program: AnyObject {   // property list
        get {
            return opStack.map{ $0.description }
        }
        set {
            if let symbols = newValue as? [String] {
                var stack = [Op]()
                for symbol in symbols {
                    if let op = knowsOp[symbol] {
                        stack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(symbol)?.doubleValue {
                        stack.append(.Operand(operand))
                    } else {
                        stack.append(.Variable(symbol))
                    }
                }
                opStack = stack
            }
            
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knowsOp[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", 2, *))
        learnOp(Op.BinaryOperation("÷", 2) { $1 / $0 })
        learnOp(Op.BinaryOperation("+", 1, +))
        learnOp(Op.BinaryOperation("−", 1) { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("ᐩ/-") { $0 * -1.0})
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("π") { M_PI * $0 })
    }
    
    func cleanData() {
        opStack.removeAll()
        variableValues = [String: Double]()
    }
    
    // MARK: - Evaluate
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Variable(let key):
                if let value = variableValues[key] {
                    return (value, remainingOps)
                } else {
                    return (nil, remainingOps)
                }
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, _, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        print("program = \(program)")
        return result
    }
    
    // MARK: - Push Or Perform
  
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
  
    func pushOperand(operand: Double?) -> Double? {
        if operand != nil {
            opStack.append(Op.Operand(operand!))
        }
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knowsOp[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func description(stack: [Op]) -> (result: String, restOp: [Op], precedence: Int) {
        if !stack.isEmpty {
            var restOp = stack
            let op = restOp.removeLast()
            switch op {
            case .Variable(let key):
                return (key, restOp, op.precedence)
            case .Operand(let operand):
                return (operand.description, restOp, op.precedence)
            case .UnaryOperation(let symbol, _):
                let (resDes, restOp1, _) = description(restOp)
                return (symbol + "(" + resDes + ")", restOp1, op.precedence)
            case .BinaryOperation(let symbol, let precedence, _):
                var (restDes1, restOp1, precedence1) = description(restOp)
                var (restDes2, restOp2, precedence2) = description(restOp1)
                if precedence > precedence1 {
                    restDes1 = "(" + restDes1 + ")"
                }
                if precedence > precedence2 {
                    restDes2 = "(" + restDes2 + ")"
                }

                return (restDes2 + symbol + restDes1, restOp2, precedence)
            }
        }
        return ("?", stack, Int.max)
    }
    
}
