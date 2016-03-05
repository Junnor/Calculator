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
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            switch self {
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    
    private var opStack = [Op]()
    private var knowsOp = [String: Op]()
    
    init() {
        
        func learnOp(op: Op) {
            knowsOp[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("ᐩ/-") { -$0 })
        learnOp(Op.UnaryOperation("%") { $0 / 100 })
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("π") { M_PI * $0 })
    }
    
    func cleanOpStack() {
        opStack.removeAll()
    }
    
    // MARK: - Evaluate
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
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
    
    private func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    // MARK: - Push Or Perform
    
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
    
}
