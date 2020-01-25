;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Hanoi World
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain DISKS)
  (:requirements :strips)
  (:predicates   (on ?x ?y)
	       (clear   ?x)
	       (holding ?x)
	       (larger ?x ?y)
	       (tweezersempty)
	       (ispic ?x)
	       )

  (:action pick-up
	     :parameters (?x ?y)
	     :precondition (and (clear ?y) (on ?x ?y) (tweezersempty))
	     :effect
	     (and (clear ?y)
		   (not (on ?x ?y))
		   (holding    ?x)
		   (not (tweezersempty))))

  (:action put-down
	     :parameters (?x ?y)
	     :precondition (and (clear ?y) (holding ?x) (ispic ?y))
	     :effect
	     (and (not (holding ?x))
	             (not (clear ?y))
		   (clear     ?x)
		   (on     ?x ?y)
		   (tweezersempty)))
  (:action stack
	     :parameters (?x ?y)
	     :precondition (and (holding ?x) (clear ?y) (larger ?y ?x))
	     :effect
	     (and (not (holding ?x))
		   (not (clear ?y))
		   (clear      ?x)
		   (on      ?x ?y)
		   (tweezersempty)))
  (:action unstack
	     :parameters (?x ?y)
	     :precondition (and (on ?x ?y) (clear ?x) (tweezersempty))
	     :effect
	     (and (holding ?x)
		   (clear ?y)
		   (not (on ?x ?y))
		   (not (tweezersempty))))
)
