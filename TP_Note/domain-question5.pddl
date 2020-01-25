;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Graphe Noeuds Monde
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain NOEUDS)
  (:requirements :strips)
  (:predicates (arc ?x ?y)
	       (on ?x)
	       )

  (:action cross
	     :parameters (?x ?y)
	     :precondition (and (on ?x) (arc ?x ?y))
	     :effect
	     (and (not (on ?x)) (on ?y))))
