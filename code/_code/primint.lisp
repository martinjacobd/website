(defun lang/eval (e env)
  (cond
   ((symbolp e)     (cadr (assoc e env)))
   ((eq (car e) '/) (cons e env))
   (t               (lang/apply (lang/eval (car e) env)
                                (lang/eval (cadr e) env)))))

(defun lang/apply (f x)
  (lang/eval (cddr (car f)) (cons (list (cadr (car f)) x) (cdr f))))
