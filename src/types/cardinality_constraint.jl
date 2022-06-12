CardinalityRelations = Set([==, >, <, <=, >=])

"""
    CardinalityConstraint

A pair holding a `Predicate` (`String`) and its cardinality.
"""
struct CardinalityConstraint
    pred::Predicate
    k::Int
    op::Function

    function CardinalityConstraint(pred::Predicate, k::Int, op::Function)
        op in CardinalityRelations || DomainError("
            Unsupported function supplied.\n
            Only operations from $CardinalityRelations are supported."
        )

        isequal(op, ==) || ArgumentError("TODO. Only CCs with equality are supported for now.")

        new(pred, k, op)
    end
end

CardinalityConstraint(pred::Predicate, k::Integer) = CardinalityConstraint(pred, k, ==)

predicate(cc::CardinalityConstraint) = cc.pred
cardinality(cc::CardinalityConstraint) = cc.k
operation(cc::CardinalityConstraint) = cc.op
