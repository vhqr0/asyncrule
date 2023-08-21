(require
  hyrule :readers * *)

(setv async-p False)

(defn get-async-name [name]
  (hy.models.Symbol (+ "Async" (str name))))

(defmacro async-if [async-form sync-form]
  (if #/ asyncrule.async-p async-form sync-form))

(defmacro async-name [name]
  `(async-if ~(#/ asyncrule.get-async-name name) ~name))

(defmacro async-wait [coro-form]
  `(async-if (await ~coro-form) ~coro-form))

(defmacro async-next [coro-form]
  `((async-if anext next) ~coro-form))

(defmacro async-for [bracket #* body]
  `(for (async-if [:async ~@bracket] ~bracket) ~@body))

(defmacro async-with [#* body]
  `(async-if (with/a ~@body) (with ~@body)))

(defmacro async-defn [#* body]
  `(async-if (defn/a ~@body) (defn ~@body)))

(defmacro async-defclass [#* args]
  (import
    hy.model-patterns [whole brackets FORM SYM]
    funcparserlib.parser [maybe many])
  (let+ [[decorators name [inherits] body]
         (-> (whole [(maybe (brackets (many FORM)))
                     SYM
                     (brackets (many FORM))
                     (many FORM)])
             (.parse args))]
    (setv decorators (if decorators (get decorators 0) '[]))
    `(do
       (eval-when-compile
         (setv #/ asyncrule.async-p False))

       (defclass ~decorators ~name ~inherits
         ~@body)

       (eval-when-compile
         (setv #/ asyncrule.async-p True))

       (defclass ~decorators ~(#/ asyncrule.get-async-name name) ~inherits
         ~@body))))

(export
  :objects [get-async-name async-p]
  :macros [async-if async-name async-wait async-next
           async-for async-with async-defn async-defclass])
