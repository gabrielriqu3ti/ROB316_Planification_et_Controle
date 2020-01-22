;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Singe Bananes World
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain BLOCKS)
  (:requirements :strips)
  (:predicates 
              (monkeyon ?x)
	    (bananaon ?x)
	    (boxon    ?x)
	    (grabbanana)
              (highmonkey)
	    )

  (:action aller
	     :parameters (?x ?y)
	     :precondition (and (not (highmonkey)) (monkeyon ?x))
	     :effect
	     (and (monkeyon ?y)
	             (not (monkeyon ?x))))

  (:action pousser
	     :parameters (?x ?y)
	     :precondition (and (not (highmonkey)) (monkeyon ?x) (boxon ?x))
	     :effect
	     (and (monkeyon ?y)
		   (boxon ?y)
		   (not (monkeyon ?x))
		   (not (boxon ?x))))
  (:action monter
	     :parameters (?x)
	     :precondition (and (not (highmonkey)) (monkeyon ?x) (boxon ?x))
	     :effect
	     (highmonkey))

  (:action descendre
	     :parameters (?x)
	     :precondition (highmonkey)
	     :effect
	     (not (highmonkey)))

  (:action attraper
	     :parameters (?x)
	     :precondition (and (highmonkey) (monkeyon ?x) (bananaon ?x))
	     :effect
	     (grabbanana))

  (:action lacher
	     :parameters (?x)
	     :precondition (grabbanana)
	     :effect
	     (not (grabbanana)))
)

