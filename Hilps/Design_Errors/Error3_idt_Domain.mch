MACHINE Error3_idt_Domain
SEES Error3_idt_Config
VARIABLES tag, mem, mem_tag, mem_type, mem_priv, mem_integrity, mem_confidentiality, mem_type_priv, 
    stack_ret, reg_mem, reg_priv, control_bit, interrupt_flag, switch_stage
DEFINITIONS
    MEM == 1..(card(MEM_TYPE) + 1);
    mem_priv_policy == (mem_type ; mem_type_priv);
    mem_map == mem_type >< mem_priv;
    ret_addr == stack_ret(mem_type(reg_mem(sp)));
    in_n2p == reg_mem(pc) : mem_type~[{n2p_gate}];
    in_p2n == reg_mem(pc) : mem_type~[{p2n_gate}];
    priv_mem == mem_type~[dom(mem_priv_diff)];
    gate_mem == mem_type~[gate_type];
    normal_mem == mem - (priv_mem \/ gate_mem);
    SET_PREF_MAX_INITIALISATIONS == 1;
    SET_PREF_MAX_OPERATIONS == 200000
INVARIANT
    (tag : TAG) &
    (mem <: MEM) &
    (mem_tag : mem --> TAG) &
    (mem_type : mem --> MEM_TYPE) &
    (mem_priv <: mem * MEM_PRIV) &
    (mem_integrity : mem --> BOOL) &
    (mem_confidentiality : MEM --> BOOL) &
    (mem_type_priv <: MEM_TYPE * MEM_PRIV) &
    (mem_priv <: mem_priv_policy) &
    (stack_ret : {normal_stack, priv_stack} --> seq(mem)) &
    (reg_mem : addr_reg --> mem) &
    (reg_priv <: REG * REG_PRIV) &
    (control_bit : CONTROL_BIT --> BOOL) &
    (interrupt_flag : BOOL) &
    (switch_stage : 0..5) &
    (execute : mem_priv[{reg_mem(pc)}]) &
    (mem_type(reg_mem(sp)) : dom(stack_ret)) &
    (tag = privileged => mem_priv_diff <: mem_type_priv) & //I1
    (tag = normal => mem_type_priv /\ mem_priv_diff = {}) & //I2
    (tag = privileged => ran(inst_priv) <: reg_priv) & //I3
    (tag = normal => reg_priv /\ ran(inst_priv) = {}) & //I4
    (mem_integrity[mem_tag~[{privileged}]] = {TRUE}) //& //I5
    //(mem_confidentiality[mem_tag~[{privileged}]] = {TRUE}) //I6
INITIALISATION
    tag := privileged ||
    mem := 1..(card(MEM_TYPE)) ; //sequential composition
    mem_type :: mem >->> MEM_TYPE ; //total bijection
    mem_tag := priv_mem * {privileged} \/ gate_mem * {gate} \/ normal_mem * {normal} ||
    mem_type_priv := (code_type * {read, execute}) \/ (data_type * {read, write}) ||
    stack_ret := {normal_stack, priv_stack} * seq({}) ||
    reg_mem := {ttbr |-> mem_type~(pt), pc |-> mem_type~(priv_code), sp |-> mem_type~(priv_stack), vbar |-> mem_type~(idt)} ||
    reg_priv := ran(inst_priv) ||
    control_bit := {sz |-> TRUE} ||
    interrupt_flag := FALSE || //non-interruptible privileged domain
    switch_stage := 0 ;
    mem_priv := mem_priv_policy ||
    mem_integrity := mem * {TRUE} ||
    mem_confidentiality := MEM * {TRUE}
OPERATIONS 
    Read(mm) =
    PRE 
        (mm : mem) &
        (switch_stage = 0) &
        (
            //check mem design error 
            ((mem_type(mm), read) /: mem_priv_diff) or
            //psi_priv
            (read : mem_priv[{mm}])
        ) &
        (   //psi_priv
            control_bit(sz) = FALSE =>
            (mem_tag(mm) /= privileged)
        ) &
        (   //secure contracts
            tag = privileged =>
            (mem_tag(mm) /= privileged)
        )
    THEN
        mem_type_priv := mem_type_priv \/ {(mem_type(mm), read)} ||
        mem_priv := mem_priv \/ {(mm, read)} ||
        mem_confidentiality(mm) := FALSE
    END;

    Write(mm) =
    PRE 
        (mm : mem) &
        (switch_stage = 0) &
        (
            (   //check mem design error 
                ((mem_type(mm), write) /: mem_priv_diff) &
                (mem_type(mm) /: code_type)
            ) or
            //psi_priv
            (write : mem_priv[{mm}])
        ) &
        (   //psi_priv
            control_bit(sz) = FALSE =>
            (mem_tag(mm) /= privileged)
        ) &
        (   //secure contracts
            tag = privileged =>
            (mem_type(mm) /: code_type) & //C1
            (mem_tag(mm) /= privileged) //C2
        )
    THEN
        mem_type_priv := mem_type_priv \/ {(mem_type(mm), write)} ||
        mem_priv := mem_priv \/ {(mm, write)} ||
        mem_integrity(mm) := FALSE
    END;

    Set_mem_map(mm, mtype, mpriv) =
    PRE 
        (mm : MEM) &
        (mtype : MEM_TYPE) &
        (mpriv <: MEM_PRIV) & //mpriv is a set, the empty set means no mapping
        (switch_stage = 0) &
        (
            ((pt, write) /: mem_priv_diff) or
            (control_bit(sz) = TRUE) or
            ((pt, write) : mem_type_priv)
        ) &
        (
            tag /= privileged
        )
    THEN
        mem := mem \/ {mm} ||
        mem_type(mm) := mtype ||
        mem_priv := ({mm} <<| (mem_priv \/ (mem_type~[{pt}] * {write}))) \/ ({mm} * mpriv) || //domain subtraction
        mem_type_priv := (mem_type_priv \/ {(pt, write)}) <+ ({mtype} * mpriv) || //relational overriding
        IF 
            tag /= privileged
        THEN
            mem_integrity := mem_integrity <+ ({(mm, TRUE)} \/ (mem_type~[{pt}] * {FALSE}))
        ELSE
            mem_integrity := mem_integrity <+ ({(mm, TRUE)} \/ (mem_type~[{pt}] * {TRUE}))
        END;
        IF 
            mtype : dom(mem_priv_diff)
        THEN
            mem_tag(mm) := privileged
        ELSIF
            mtype : gate_type
        THEN
            mem_tag(mm) := gate
        ELSE
            mem_tag(mm) := normal
        END
    END;

    /*Remap_attack(mm, mtype, mpriv) =
    PRE 
        (mm : MEM) &
        (mtype : MEM_TYPE) &
        (mpriv <: MEM_PRIV) &
        (switch_stage = 0) &
        (tag /= privileged)
        //bypass the privilege check
    THEN
        mem := mem \/ {mm} ||
        mem_type(mm) := mtype ||
        mem_priv := ({mm} <<| (mem_priv \/ (mem_type~[{pt}] * {write}))) \/ ({mm} * mpriv) ||
        mem_type_priv := (mem_type_priv \/ {(pt, write)}) <+ ({mtype} * mpriv) ||
        IF 
            tag /= privileged
        THEN
            mem_integrity := mem_integrity <+ ({(mm, TRUE)} \/ (mem_type~[{pt}] * {FALSE}))
        ELSE
            mem_integrity := mem_integrity <+ ({(mm, TRUE)} \/ (mem_type~[{pt}] * {TRUE}))
        END;
        IF 
            mtype : dom(mem_priv_diff)
        THEN
            mem_tag(mm) := privileged
        ELSIF
            mtype : gate_type
        THEN
            mem_tag(mm) := gate
        ELSE
            mem_tag(mm) := normal
        END
    END;*/

    Set_ttbr(mm) =
    PRE 
        (mm : MEM) &
        (mm /: dom(mem_type)) &
        (switch_stage = 0) &
        (
            (ttbr, set) /: ran(inst_priv) or
            ((ttbr, set) : reg_priv)
        )
    THEN
        mem := (mem - mem_type~[{pt}]) \/ {mm} ||
        mem_tag := (mem_type~[{pt}] <<| mem_tag) \/ {(mm, privileged)} ||
        mem_type := (mem_type |>> {pt}) \/ {mm |-> pt} || //range subtraction
        mem_priv := (mem_type~[{pt}] <<| mem_priv) \/ {(mm, read), (mm, write)} ||
        IF 
            tag /= privileged
        THEN
            mem_integrity := (mem_type~[{pt}] <<| mem_integrity) \/ {mm |-> FALSE}
        ELSE
            mem_integrity := (mem_type~[{pt}] <<| mem_integrity) \/ {mm |-> TRUE}
        END ||
        mem_type_priv := mem_type_priv \/ {(pt, read), (pt, write)} ||
        reg_mem(ttbr) := mm ||
        reg_priv := reg_priv \/ {(ttbr, set)}
    END;

    /*Attack_ttbr(mm) =
    PRE 
        (mm : MEM) &
        (mm /: dom(mem_type)) &
        (switch_stage = 0)
    THEN
        mem := (mem - mem_type~[{pt}]) \/ {mm} ||
        mem_tag := (mem_type~[{pt}] <<| mem_tag) \/ {(mm, privileged)} ||
        mem_type := (mem_type |>> {pt}) \/ {mm |-> pt} ||
        mem_priv := (mem_type~[{pt}] <<| mem_priv) \/ {(mm, read), (mm, write)} ||
        IF 
            tag /= privileged
        THEN
            mem_integrity := (mem_type~[{pt}] <<| mem_integrity) \/ {mm |-> FALSE}
        ELSE
            mem_integrity := (mem_type~[{pt}] <<| mem_integrity) \/ {mm |-> TRUE}
        END ||
        mem_type_priv := mem_type_priv \/ {(pt, read), (pt, write)} ||
        reg_mem(ttbr) := mm ||
        reg_priv := reg_priv \/ {(ttbr, set)}
    END;*/

    Set_io_map(mm, mpriv) =
    PRE 
        (mm : mem) &
        (mpriv = {write})&
        (switch_stage = 0) &
        (
            ((iopt, write) /: mem_priv_diff) or
            (control_bit(sz) = TRUE) or
            ((iopt, write) : mem_type_priv)
        ) &
        (
            tag = privileged =>
            (
                (mem_tag(mm) /= privileged) &
                (mem_type(mm) /: code_type)
            )
        )
    THEN
        mem_priv := ({mm} <<| (mem_priv \/ (mem_type~[{iopt}] * {write}))) \/ ({mm} * mpriv) ||
        mem_type_priv := (mem_type_priv \/ {(iopt, write)}) <+ ({mem_type(mm)} * mpriv) ||
        IF 
            tag /= privileged
        THEN
            mem_integrity := (mem_type~[{iopt}] <<| mem_integrity) \/ (mem_type~[{iopt}] * {FALSE})
        ELSE
            mem_integrity := (mem_type~[{iopt}] <<| mem_integrity) \/ (mem_type~[{iopt}] * {TRUE})
        END
    END;

    /*Attack_io(mm, mpriv) =
    PRE 
        (mm : mem) &
        (mpriv = {write})&
        (switch_stage = 0) &
        (
            tag = privileged =>
            (
                (mem_tag(mm) /= privileged) &
                (mem_type(mm) /: code_type)
            )
        )
    THEN
        mem_priv := ({mm} <<| (mem_priv \/ (mem_type~[{iopt}] * {write}))) \/ ({mm} * mpriv) ||
        mem_type_priv := (mem_type_priv \/ {(iopt, write)}) <+ ({mem_type(mm)} * mpriv) ||
        IF 
            tag /= privileged
        THEN
            mem_integrity := (mem_type~[{iopt}] <<| mem_integrity) \/ (mem_type~[{iopt}] * {FALSE})
        ELSE
            mem_integrity := (mem_type~[{iopt}] <<| mem_integrity) \/ (mem_type~[{iopt}] * {TRUE})
        END
    END;*/

    Set_iommu_control(mm) =
    PRE 
        (mm : MEM) &
        (mm /: dom(mem_type)) &
        (switch_stage = 0) &
        (
            ((iommu_control, write) /: mem_priv_diff) or
            (control_bit(sz) = TRUE) or
            ((iommu_control, write) : mem_type_priv)
        ) &
        (tag /= privileged)
    THEN
        mem := (mem - mem_type~[{iopt}]) \/ {mm} ||
        mem_tag := (mem_type~[{iopt}] <<| mem_tag) \/ {(mm, privileged)} ||
        mem_type := (mem_type |>> {iopt}) \/ {mm |-> iopt} ||
        mem_priv := (mem_type~[{iopt}] <<| mem_priv) \/ (mem_type~[{iommu_control}] * {write}) \/ {(mm, read), (mm, write)} ||
        mem_integrity := (mem_type~[{iommu_control, iopt}] <<| mem_integrity) \/ (mem_type~[{iommu_control}] * {FALSE}) \/ {mm |-> TRUE} ||
        mem_type_priv := mem_type_priv \/ {(iommu_control, write), (iopt, read), (iopt, write)}
    END;

    Call(mm) =
    PRE 
        (mm : mem) &
        (switch_stage = 0) &
        (execute : mem_priv[{mm}]) &
        (mm /= reg_mem(pc)) &
        (reg_mem(pc) /: ran(ret_addr)) &
        (
            ((mem_type(reg_mem(sp)), write) /: mem_priv_diff) or
            (control_bit(sz) = TRUE) or
            ((mem_type(reg_mem(sp)), write) : mem_type_priv)
        ) &
        (
            tag = privileged =>
            (
                mem_tag(mm) /= normal //C3
            )
        )
    THEN
        mem_type_priv := mem_type_priv \/ {(mem_type(reg_mem(sp)), write)} ||
        mem_priv := mem_priv \/ {(reg_mem(sp), write)} ||
        stack_ret(mem_type(reg_mem(sp))) := ret_addr <- reg_mem(pc) ||
        reg_mem(pc) := mm ||
        IF 
            mm : mem_type~[gate_type]
        THEN
            switch_stage := switch_stage + 1
        END
    END;

    Ret =
    PRE
        (ret_addr /= []) &
        (switch_stage = 0)
    THEN
        reg_mem(pc) := last(ret_addr) ||
        tag := mem_tag(last(ret_addr)) ||
        stack_ret(mem_type(reg_mem(sp))) := front(ret_addr)
    END;

    Jump(mm) =
    PRE 
        (mm : mem) &
        (mm /= reg_mem(pc)) &
        (
            (
                ((mem_type(mm), execute) /: mem_priv_diff) &
                (mem_type(mm) : code_type)
            ) or
            (execute : mem_priv[{mm}])
        ) &
        (
            (switch_stage = 0) or
            (
                (switch_stage = 5) &
                in_n2p &
                (mem_type(mm) = priv_code)
            ) or
            (
                (switch_stage = 5) &
                in_p2n &
                (mem_type(mm) = normal_code)
            )
        ) &
        (
            tag = privileged =>
            (
                mem_tag(mm) /= normal //C3
            )
        )
    THEN
        mem_type_priv := mem_type_priv \/ {(mem_type(mm), execute)} ||
        mem_priv := mem_priv \/ {(mm, execute)} ;
        IF 
            (switch_stage = 5) & in_n2p
        THEN
            tag := privileged ||
            reg_priv := reg_priv \/ ran(inst_priv) ||
            mem_type_priv := mem_type_priv \/ mem_priv_diff ;
            mem_priv := mem_priv_policy
        ELSIF
            (switch_stage = 5) & in_p2n
        THEN
            tag := normal ||
            reg_priv := reg_priv - ran(inst_priv)
        END ||
        IF 
            (mm : mem_type~[{n2p_gate}]) or
            (mm : mem_type~[{p2n_gate}])
        THEN
            switch_stage := switch_stage + 1
        ELSE
            switch_stage := 0
        END ||
        reg_mem(pc) := mm
    END;

    Set_tcr(bits) =
    PRE 
        (bits : reg_bit[{tcr}] --> BOOL) &
        (
            ((tcr, set) /: ran(inst_priv)) or
            ((tcr, set) : reg_priv)
        ) &
        (
            (switch_stage = 0) or
            (
                (switch_stage = 3) &
                in_n2p &
                (bits = {sz |-> TRUE})
            ) or
            (
                (switch_stage = 3) &
                in_p2n &
                (bits = {sz |-> FALSE}) //loop check
            )
        ) &
        (
            tag = privileged =>
            in_p2n
        )
    THEN
        reg_priv := reg_priv \/ {(tcr, set)} ||
        control_bit := control_bit <+ bits ||
        IF 
            (sz, FALSE) : bits 
        THEN
            mem_type_priv := mem_type_priv - mem_priv_diff ;
            mem_priv := mem_priv_policy
        END ||
        IF 
            switch_stage /= 0
        THEN
            switch_stage := switch_stage + 1
        END
    END;

    Set_sctlr(bb) =
    PRE 
        (bb : BOOL) & 
        (switch_stage = 0) &
        (
            (sctlr, set) /: ran(inst_priv) or
            ((sctlr, set) : reg_priv)
        ) &
        (
            tag = privileged =>
            (bb /= FALSE)
        )
    THEN
        IF 
            bb = TRUE
        THEN
            control_bit(sz) := TRUE
        ELSE
            control_bit(sz) := FALSE
        END ||
        reg_priv := reg_priv \/ {(sctlr, set)}
    END;

    /*Attack_tcr(bits) =
    PRE 
        (bits : reg_bit[{tcr}] --> BOOL) &
        (
            (switch_stage = 0) or
            (
                (switch_stage = 3) &
                in_n2p &
                (bits = {sz |-> TRUE})
            ) or
            (
                (switch_stage = 3) &
                in_p2n &
                (bits = {sz |-> FALSE})
            )
        ) &
        (
            tag = privileged =>
            in_p2n
        )
    THEN
        reg_priv := reg_priv \/ {(tcr, set)} ||
        control_bit := control_bit <+ bits ||
        IF 
            (sz, FALSE) : bits 
        THEN
            mem_type_priv := mem_type_priv - mem_priv_diff ;
            mem_priv := mem_priv_policy
        END ||
        IF 
            switch_stage /= 0
        THEN
            switch_stage := switch_stage + 1
        END
    END;*/

    Disable_interrupt =
    PRE 
        ((switch_stage = 0) & (tag /= privileged)) or
        ((switch_stage = 2) & in_n2p)
    THEN
        IF 
            switch_stage /= 0
        THEN
            switch_stage := switch_stage + 1
        END ||
        interrupt_flag := FALSE
    END;

    Enable_interrupt =
    PRE 
        //((switch_stage = 0) & tag /= privileged) or
        //malicious interrupt
        (switch_stage = 0) or
        ((switch_stage = 4) & in_p2n)
    THEN
        IF 
            switch_stage /= 0
        THEN
            switch_stage := switch_stage + 1
        END ||
        interrupt_flag := TRUE
    END;

    Interrupt =
    PRE
        (interrupt_flag = TRUE)
        //TRUE = TRUE //malicious interrupt
        //tag = gate //malicious gate interrupt
    THEN
        IF 
            FALSE /: mem_integrity[mem_type~[{idt}]]
        THEN
            //privilege setting
            control_bit(sz) := FALSE ||
            mem_type_priv := mem_type_priv - mem_priv_diff ;
            mem_priv := mem_priv_policy
        END ||
        tag := normal ||
        //reg_mem(pc) :: mem_type~[{normal_code}] //choice from set
        ANY xx
        WHERE
            xx : mem_type~[{normal_code}]
        THEN
            reg_mem(pc) := xx
        END ||
        reg_priv := reg_priv - ran(inst_priv) ||
        switch_stage := 0
    END;

    /*Attack_interrupt =
    PRE
        (interrupt_flag = TRUE)
    THEN
        tag := normal ||
        ANY xx
        WHERE
            xx : mem_type~[{normal_code}]
        THEN
            reg_mem(pc) := xx
        END ||
        reg_priv := reg_priv - ran(inst_priv) ||
        switch_stage := 0
    END;*/

    Set_vbar(mm) =
    PRE 
        (mm : MEM) &
        (mm /: dom(mem_type)) &
        (switch_stage = 0) &
        (
            ((vbar, set) /: ran(inst_priv)) or
            ((vbar, set) : reg_priv)
        )
    THEN
        reg_priv := reg_priv \/ {(vbar, set)} ||
        mem := (mem - mem_type~[{idt}]) \/ {mm} ||
        IF 
            idt : dom(mem_priv_diff)
        THEN
            mem_tag := (mem_type~[{idt}] <<| mem_tag) \/ {(mm, privileged)}
        ELSE
            mem_tag := (mem_type~[{idt}] <<| mem_tag) \/ {(mm, normal)}
        END ||
        mem_type := (mem_type |>> {idt}) \/ {mm |-> idt} ||
        mem_priv := (mem_type~[{idt}] <<| mem_priv) \/ {(mm, read), (mm, write)} ||
        mem_type_priv := mem_type_priv \/ {(idt, read), (idt, write)} ||
        reg_mem(vbar) := mm ||
        IF
            tag /= privileged
        THEN
            mem_integrity := (mem_type~[{idt}] <<| mem_integrity) \/ {mm |-> FALSE}
        ELSE
            mem_integrity := (mem_type~[{idt}] <<| mem_integrity) \/ {mm |-> TRUE}
        END
    END;

    /*Attack_vbar(mm) =
    PRE 
        (mm : MEM) &
        (mm /: dom(mem_type)) &
        (switch_stage = 0)
    THEN
        reg_priv := reg_priv \/ {(vbar, set)} ||
        mem := (mem - mem_type~[{idt}]) \/ {mm} ||
        IF 
            idt : dom(mem_priv_diff)
        THEN
            mem_tag := (mem_type~[{idt}] <<| mem_tag) \/ {(mm, privileged)}
        ELSE
            mem_tag := (mem_type~[{idt}] <<| mem_tag) \/ {(mm, normal)}
        END ||
        mem_type := (mem_type |>> {idt}) \/ {mm |-> idt} ||
        mem_priv := (mem_type~[{idt}] <<| mem_priv) \/ {(mm, read), (mm, write)} ||
        mem_type_priv := mem_type_priv \/ {(idt, read), (idt, write)} ||
        reg_mem(vbar) := mm ||
        IF
            tag /= privileged
        THEN
            mem_integrity := (mem_type~[{idt}] <<| mem_integrity) \/ {mm |-> FALSE}
        ELSE
            mem_integrity := (mem_type~[{idt}] <<| mem_integrity) \/ {mm |-> TRUE}
        END
    END;*/

    Change_stack =
    PRE 
        ((switch_stage = 4) & in_n2p) or
        ((switch_stage = 2) & in_p2n)
    THEN
        switch_stage := switch_stage + 1 ||
        VAR to_stack
        IN
            IF 
                in_n2p
            THEN
                to_stack := priv_stack ||
                mem_type_priv := mem_type_priv \/ {(priv_code, execute)} ||
                mem_priv := mem_priv \/ (mem_type~[{priv_code}] * {execute})
            ELSE
                to_stack := normal_stack
            END ;
            ANY xx
            WHERE
                xx : mem_type~[{to_stack}]
            THEN
                reg_mem(sp) := xx
            END
            //reg_mem(sp) :: mem_type~[{to_stack}]
        END
    END;

    /*Attack_stack(mm) =
    PRE 
        (mm : mem) &
        (tag = normal) &
        (execute : mem_priv[{mm}]) &
        (mem_tag(mm) = normal) &
        (
            (control_bit(sz) = TRUE) or
            ((priv_stack, write) /: mem_priv_diff) or
            ((mem_type~[{priv_stack}] * {write}) /\ mem_priv /= {})
        ) &
        (stack_ret(priv_stack) /= []) &
        (mm /: ran(stack_ret(priv_stack)))
    THEN
        mem_type_priv := mem_type_priv \/ {(priv_stack, write)} ||
        mem_priv := mem_priv \/ (mem_type~[{priv_stack}] * {write}) ||
        stack_ret(priv_stack) := front(stack_ret(priv_stack)) <- mm
    END;*/

    Switch_n2p =
    PRE
        (switch_stage = 1) &
        in_n2p
    THEN
        tag := gate ||
        switch_stage := switch_stage + 1 ||
        reg_priv := reg_priv \/ {(tcr, set)}
    END;

    Switch_p2n =
    PRE
        (switch_stage = 1) &
        in_p2n
    THEN
        tag := gate ||
        switch_stage := switch_stage + 1 ||
        reg_priv := reg_priv \/ {(tcr, set)}
    END
END//MACHINE