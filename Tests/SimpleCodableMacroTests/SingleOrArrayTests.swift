import Foundation
import Testing
import SimpleCodableMacro

@SingleOrArray
enum TextInputValue {
    case text(String)
    case texts([String])
}

@Suite
struct SingleOrArrayTests {
    @Test
    func decodesAndEncodesSingleAndArrayShapes() throws {
        let single = try TestJSON.decode(TextInputValue.self, from: #""hello""#)
        let multiple = try TestJSON.decode(TextInputValue.self, from: #"["a","b"]"#)

        #expect(single == .text("hello"))
        #expect(multiple == .texts(["a", "b"]))
        #expect(try TestJSON.string(from: single) == #""hello""#)
        #expect(try TestJSON.string(from: multiple) == #"["a","b"]"#)
        print(single)
        print(multiple)
    }

    @Test
    func supportsSingleAndArrayLiteralInitialization() {
        let single: TextInputValue = "hello"
        let multiple: TextInputValue = ["a", "b"]

        #expect(single == .text("hello"))
        #expect(multiple == .texts(["a", "b"]))
        print(single)
        print(multiple)
    }
}
