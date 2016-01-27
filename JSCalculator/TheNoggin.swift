//
//  ViewController.swift
//  TheNoggin
//
//  Created by Jaxon Stevens on 1/25/16.
//  Copyright © 2016 Jaxon Stevens. All rights reserved.
//


//Please Note: This Swift File is not used within the calculator (Read Below)

// I decided to play around with another way of coding a calculator first, without success I realized that by using the method below it would not work when the application was run. The method below used to work but due to recent changes in the Swift programming language this method shown below no longer preforms or calculates properly.

// I thought I would leave it here anyways




import Foundation

class TheNoggin {
    
    private let pi3 = M_PI
    
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double ->Double)
        case BinaryOperation(String, (Double, Double) ->Double)
        case PiValue (String, Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .PiValue(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
                
            }
        }
    }
    
    var description: String {
        let (result, reminder) = description(opStack)

        if result != nil {
            return result!
        } else {
            return "oooops"
        }
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .PiValue(let symbol, _):
                return (symbol, remainingOps)
            case .Variable(let symbol):
                return (symbol, remainingOps)
                
            case .UnaryOperation(let operation, _):
                let opDescription = description(remainingOps)
                if let operand = opDescription.result {
                    return ("\(operation)(\(operand))", opDescription.remainingOps)
                } else {
                    return ("\(operation)(?)", opDescription.remainingOps)
                }
                
            case .BinaryOperation(let operation, _):
               
                var op1 = "?"
                var op2 = "?"
                var returningOps = remainingOps
                
                
                let op1Description = description(remainingOps)
                if let operand1 = op1Description.result {
                    
                    
                    returningOps = op1Description.remainingOps
                    op2 = operand1
                    
                    
                    
                    let op2Description = description(op1Description.remainingOps)
                    if let operand2 = op2Description.result {
                       
                        
                        
                        returningOps = op2Description.remainingOps
                        op1 = operand2
                    }
                                   }
                return ("(\(op1)" + "\(operation)" + "\(op2))", returningOps)
            }
            
        }
        return (nil, ops)
    }
    
    private var opStack = Array<Op>()
    private var knownOps = Dictionary<String, Op>()
    var varibaleValues = [String: Double]()
    
    init (){
        func learnOp(op: Op) {knownOps[op.description] = op}
        learnOp(Op.BinaryOperation("×", *))
        
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["π"] = Op.PiValue("π", pi3)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
    }
    

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
                
            case .PiValue(_, let value):
                return (value, remainingOps)
                
            case .Variable(let symbol):
                let temp_operand = varibaleValues[symbol]
                return (temp_operand, remainingOps)
            }
            
        }
        
        return (nil, ops)
    }
    
    
    
    func evaluate() -> Double? {
        let (result, reminder) = evaluate(opStack)
        
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func pushOperand(symbol:String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
}