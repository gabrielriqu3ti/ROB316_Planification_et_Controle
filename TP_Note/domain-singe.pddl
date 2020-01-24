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
	    (dropbanana)
              (highmonkey)
	    (lowmonkey)
	    )

  (:action aller
	     :parameters (?x ?y)
	     :precondition (and  (lowmonkey) (monkeyon ?x)) ; nao pode colocar not na precondition 
	     :effect
	     (and (monkeyon ?y)
	             (not (monkeyon ?x))))

  (:action pousser
	     :parameters (?x ?y)
	     :precondition (and (lowmonkey) (monkeyon ?x) (boxon ?x))
	     :effect
	     (and (monkeyon ?y)
		   (boxon ?y)
		   (not (monkeyon ?x))
		   (not (boxon ?x))))

  (:action monter
	     :parameters (?x)
	     :precondition (and (lowmonkey) (monkeyon ?x) (boxon ?x) (bananaon ?x))
	     :effect
	     (highmonkey))

  (:action descendre
	     :parameters (?x)
	     :precondition (highmonkey)
	     :effect
	     (lowmonkey))

  (:action attraper
	     :parameters (?x)
	     :precondition (and (highmonkey) (monkeyon ?x) (bananaon ?x))
	     :effect
	     (grabbanana))

  (:action lacher
	     :parameters (?x)
	     :precondition (grabbanana)
	     :effect
	     (dropbanana))
)

