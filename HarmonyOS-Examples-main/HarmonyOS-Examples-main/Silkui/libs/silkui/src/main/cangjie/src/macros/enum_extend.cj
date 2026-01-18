/**
 * Created on 2025/4/27
 */
macro package silkui.macros
import std.ast.*

public macro EnumExtend (input: Tokens) {
    let inp = EnumDecl(input)
    if (inp.keyword.kind != TokenKind.ENUM) {
        diagReport(DiagReportLevel.ERROR, inp.keyword.toTokens(), "Must be applied to a Enum",
                "Expecting a Enum declaration")
    }
    if (inp.constructors.size == 0) {
        diagReport(DiagReportLevel.ERROR, inp.identifier.toTokens(), "Enum must have at least one constructor",
                "Expecting a Enum declaration")
    }
    let result: Tokens = quote( )
    result.append(input)
    let arrays: Tokens = quote()
    for (i in 0..inp.constructors.size) {
        let c = inp.constructors[i]
        arrays.append(quote(
            ($(c.identifier.toTokens()), $(c.identifier.toTokens()))
        ))
        if (i != inp.constructors.size - 1) {
            arrays.append(quote(|))
        }
    }
    result.append(quote(
        extend $(inp.identifier.toTokens()) <: Equatable<$(inp.identifier.toTokens())> {
            public operator func ==(r: $(inp.identifier.toTokens())): Bool {
                match((this, r)) {
                    case $(arrays) => true
                    case _ => false
                }
            }

            public operator func !=(r: $(inp.identifier.toTokens())): Bool {
                !(this == r)
            }
        }
    ))
    return result
}