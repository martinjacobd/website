(defun nilp (e)
  (eq e nil))

; Hash tables are annoyingly mutable
(defun copy-hash-table (table)
  (let ((newtable (make-hash-table
				   :test (hash-table-test table)
				   :size (hash-table-size table))))
	(maphash (lambda (key value)
			   (setf (gethash key newtable) value))
			 table)
	newtable))

(defun nilp (e)
  (eq e nil))

(defun lang/env/setvar (env var val)
  (setf (gethash var env) val)
  env)

(defun lang/env/extend (env vars vals)
  (let* ((newenv (copy-hash-table env))
		 (setenv (lambda (var val)
				   (lang/env/setvar newenv var val))))
	(mapcar setenv vars vals)
	newenv))

(defun lang/eval (e env)
  (cond
   ((symbolp e)       (list (car (gethash e env)) env))
   ((numberp e)       (list e env))
   ((eq (car e) '/)   (list e env))
   ((eq (car e) 'let) (lang/eval/let (caddr e) env (cadr e)))
   (t                 (lang/apply (lang/eval (car e) env)
								  (lang/eval (cadr e) env)))))

(defun lang/eval/withenv (env)
  (lambda (e) (lang/eval e env)))

(defun lang/eval/let (e env binds)
  (let* ((vars   (mapcar #'car binds))
		 (exps   (mapcar #'cadr binds))
		 (vals   (mapcar (lang/eval/withenv env) exps))
		 (newenv (lang/env/extend env vars vals)))
	(lang/eval e newenv)))

(defun lang/apply (f x)
  (lang/eval (cddr (car f)) (lang/env/extend (cadr f) (cadr (car f)) (list x))))

(print (lang/eval '((/ (a) . a) (/ (b) . b)) (make-hash-table)))
(print (lang/eval '(let ((id (/ (x) . x))) (id (/ (a) . a))) (make-hash-table)))
