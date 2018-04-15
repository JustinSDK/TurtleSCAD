# Lambda spiral

The (archimedean) spiral is formed by a lambda expression shown below. It performs computation similar to `[1, 2, 3].map(elem => elem - 1)` (JavaScript).

 `(f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(m => l => f => (_ => _)((l => l(_ => _ => (_ => f => f(_ => _))))(l))(_ => (_ => (f => _ => f(_ => _))))(_ => (h => t => (l => r => f => f(l)(r))(h)(t))(f((p => p(l => _ => l))(l)))(m((p => p(_ => r => r))(l))(f))))((e => (l => (f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(v => r => l => (_ => _)((l => l(_ => _ => (_ => f => f(_ => _))))(l))(_ => r)(_ => v((h => t => (l => r => f => f(l)(r))(h)(t))((p => p(l => _ => l))(l))(r))((p => p(_ => r => r))(l))))(_ => (f => _ => f(_ => _)))(l))(e(_ => _ => (f => _ => f(_ => _)))))((f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(r => t => h => (_ => _)((n => n(_ => (_ => f => f(_ => _)))(_ => f => f(_ => _)))(h))(_ => t)(_ => r((h => t => (l => r => f => f(l)(r))(h)(t))(h)(t))))(_ => (f => _ => f(_ => _)))(f => x => f(x))(f => x => f(f(x)))(f => x => f(f(f(x))))))(e => (m => n => n(n => (p => p(l => _ => l))(n(p => (l => r => f => f(l)(r))((p => p(_ => r => r))(p))((n => f => x => f(n(f)(x)))((p => p(_ => r => r))(p))))((l => r => f => f(l)(r))(_ => _)(_ => x => x))))(m))(e)(f => x => f(x)))` 

The expression is also a legal ES6 arrow function. You can save the following code to a .js and use [Node.js](https://nodejs.org/en/) to run it. 

    let lt = (f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(m => l => f => (_ => _)((l => l(_ => _ => (_ => f => f(_ => _))))(l))(_ => (_ => (f => _ => f(_ => _))))(_ => (h => t => (l => r => f => f(l)(r))(h)(t))(f((p => p(l => _ => l))(l)))(m((p => p(_ => r => r))(l))(f))))((e => (l => (f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(v => r => l => (_ => _)((l => l(_ => _ => (_ => f => f(_ => _))))(l))(_ => r)(_ => v((h => t => (l => r => f => f(l)(r))(h)(t))((p => p(l => _ => l))(l))(r))((p => p(_ => r => r))(l))))(_ => (f => _ => f(_ => _)))(l))(e(_ => _ => (f => _ => f(_ => _)))))((f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(r => t => h => (_ => _)((n => n(_ => (_ => f => f(_ => _)))(_ => f => f(_ => _)))(h))(_ => t)(_ => r((h => t => (l => r => f => f(l)(r))(h)(t))(h)(t))))(_ => (f => _ => f(_ => _)))(f => x => f(x))(f => x => f(f(x)))(f => x => f(f(f(x))))))(e => (m => n => n(n => (p => p(l => _ => l))(n(p => (l => r => f => f(l)(r))((p => p(_ => r => r))(p))((n => f => x => f(n(f)(x)))((p => p(_ => r => r))(p))))((l => r => f => f(l)(r))(_ => _)(_ => x => x))))(m))(e)(f => x => f(x)));

    console.log(array(lt)); // show [0, 1, 2]

    function natural(n) {
        return n(i => i + 1)(0);
    }

    function array(lt) {
        let unit = _ => _;
        let no_use = unit;

        let yes = f => _ => f(no_use);
        let no = _ => f => f(no_use); 
        let when = unit;

        let pair = l => r => f => f(l)(r);
        let left = p => p(l => _ => l);
        let right = p => p(_ => r => r);

        let nil = _ => yes;
        let con = h => t => pair(h)(t);
        let head = left;
        let tail = right;

        let is_nil = l => l(_ => _ => no);
        let isEmpty = is_nil;

        function arr(acc, l) {
            return when(isEmpty(l))
                    (() => acc)
                    (() => arr(acc.concat([natural(head(l))]), tail(l)));
        }
        return arr([], lt);
    }

![lambda spiral](https://cdn.thingiverse.com/renders/5b/81/d2/b4/46/046999f5af361ccc283cd42348df2951_preview_featured.JPG)