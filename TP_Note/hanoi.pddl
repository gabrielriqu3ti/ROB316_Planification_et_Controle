(define (problem DISKS-4-0)
(:domain DISKS)
(:objects D1 D2 D3 D4 D5 PIC1 PIC2 PIC3)
(:INIT (TWEEZERSEMPTY) (LARGER D5 D4) (LARGER D5 D3) (LARGER D5 D2) (LARGER D5 D1)
                       (LARGER D4 D3) (LARGER D4 D2) (LARGER D4 D1)
                       (LARGER D3 D2) (LARGER D3 D1) 
                       (LARGER D2 D1) 
                       (CLEAR D1) (CLEAR PIC2) (CLEAR PIC3) 
                       (ON D5 PIC1) (ON D4 D5) (ON D3 D4) (ON D2 D3) (ON D1 D2)
                       (ISPIC PIC1) (ISPIC PIC2) (ISPIC PIC3)
                       )
(:goal (AND (CLEAR D1) (CLEAR PIC1) (CLEAR PIC2) (ON D5 PIC3) (ON D4 D5) (ON D3 D4) (ON D2 D3) (ON D1 D2)))
)