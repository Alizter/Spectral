-- Authors: Floris van Doorn

import homotopy.smash ..move_to_lib .pushout

open bool pointed eq equiv is_equiv sum bool prod unit circle cofiber prod.ops wedge is_trunc function

  /- smash A (susp B) = susp (smash A B) <- this follows from associativity and smash with S¹ -/

  /- To prove: Σ(X × Y) ≃ ΣX ∨ ΣY ∨ Σ(X ∧ Y) (notation means suspension, wedge, smash),
     and both are equivalent to the reduced join -/

  /- To prove: associative -/

  /- smash A B ≃ pcofiber (pprod_of_pwedge A B) -/

variables {A B : Type*}

namespace smash

  definition prod_of_wedge [unfold 3] (v : pwedge A B) : A × B :=
  begin
    induction v with a b ,
    { exact (a, pt) },
    { exact (pt, b) },
    { reflexivity }
  end

  definition wedge_of_sum [unfold 3] (v : A + B) : pwedge A B :=
  begin
    induction v with a b,
    { exact pushout.inl a },
    { exact pushout.inr b }
  end


  definition prod_of_wedge_of_sum [unfold 3] (v : A + B) : prod_of_wedge (wedge_of_sum v) = prod_of_sum v :=
  begin
    induction v with a b,
    { reflexivity },
    { reflexivity }
  end

end smash open smash

namespace pushout

  definition eq_inl_pushout_wedge_of_sum [unfold 3] (v : pwedge A B) :
    inl pt = inl v :> pushout wedge_of_sum bool_of_sum :=
  begin
    induction v with a b,
    { exact glue (sum.inl pt) ⬝ (glue (sum.inl a))⁻¹, },
    { exact ap inl (glue ⋆) ⬝ glue (sum.inr pt) ⬝ (glue (sum.inr b))⁻¹, },
    { apply eq_pathover_constant_left,
      refine !con.right_inv ⬝pv _ ⬝vp !con_inv_cancel_right⁻¹, exact square_of_eq idp }
  end

  variables (A B)
  definition eq_inr_pushout_wedge_of_sum [unfold 3] (b : bool) :
    inl pt = inr b :> pushout (@wedge_of_sum A B) bool_of_sum :=
  begin
    induction b,
    { exact glue (sum.inl pt) },
    { exact ap inl (glue ⋆) ⬝ glue (sum.inr pt) }
  end

  definition is_contr_pushout_wedge_of_sum : is_contr (pushout (@wedge_of_sum A B) bool_of_sum) :=
  begin
    apply is_contr.mk (pushout.inl pt),
    intro x, induction x with v b w,
    { apply eq_inl_pushout_wedge_of_sum },
    { apply eq_inr_pushout_wedge_of_sum },
    { apply eq_pathover_constant_left_id_right,
      induction w with a b,
      { apply whisker_rt, exact vrfl },
      { apply whisker_rt, exact vrfl }}
  end

end pushout open pushout

namespace smash

  variables (A B)
  definition smash_equiv_cofiber : smash A B ≃ cofiber (@prod_of_wedge A B) :=
  begin
    unfold [smash, cofiber, smash'], symmetry,
    refine !pushout.symm ⬝e _,
    fapply pushout_compose_equiv wedge_of_sum,
    { symmetry, apply equiv_unit_of_is_contr, apply is_contr_pushout_wedge_of_sum },
    { intro x, reflexivity },
    { apply prod_of_wedge_of_sum }
  end

  definition pprod_of_pwedge [constructor] : pwedge A B →* A ×* B :=
  begin
    fconstructor,
    { exact prod_of_wedge },
    { reflexivity }
  end

  definition smash_pequiv_pcofiber [constructor] : smash A B ≃* pcofiber (pprod_of_pwedge A B) :=
  begin
    apply pequiv_of_equiv (smash_equiv_cofiber A B),
    exact (cofiber.glue pt)⁻¹
  end

  variables {A B}

  /- commutativity -/

  definition smash_flip (x : smash A B) : smash B A :=
  begin
    induction x,
    { exact smash.mk b a },
    { exact auxr },
    { exact auxl },
    { exact gluer a },
    { exact gluel b }
  end

  definition smash_flip_smash_flip (x : smash A B) : smash_flip (smash_flip x) = x :=
  begin
    induction x,
    { reflexivity },
    { reflexivity },
    { reflexivity },
    { apply eq_pathover_id_right,
      refine ap_compose' smash_flip _ _ ⬝ ap02 _ !elim_gluel ⬝ !elim_gluer ⬝ph _,
      apply hrfl },
    { apply eq_pathover_id_right,
      refine ap_compose' smash_flip _ _ ⬝ ap02 _ !elim_gluer ⬝ !elim_gluel ⬝ph _,
      apply hrfl }
  end

  definition smash_comm : smash A B ≃* smash B A :=
  begin
    fapply pequiv_of_equiv,
    { apply equiv.MK, do 2 exact smash_flip_smash_flip },
    { reflexivity }
  end

  /- smash A S¹ = susp A -/
  open susp

  definition psusp_of_smash_pcircle [unfold 2] (x : smash A S¹*) : psusp A :=
  begin
    induction x using smash.elim,
    { induction b, exact pt, exact merid a ⬝ (merid pt)⁻¹ },
    { exact pt },
    { exact pt },
    { reflexivity },
    { induction b, reflexivity, apply eq_pathover_constant_right, apply hdeg_square,
      exact !elim_loop ⬝ !con.right_inv }
  end

  definition smash_pcircle_of_psusp [unfold 2] (x : psusp A) : smash A S¹* :=
  begin
    induction x,
    { exact pt },
    { exact pt },
    { exact gluel' pt a ⬝ ap (smash.mk a) loop ⬝ gluel' a pt },
  end

 -- the definitions below compile, but take a long time to do so and have sorry's in them
  definition smash_pcircle_of_psusp_of_smash_pcircle_pt [unfold 3] (a : A) (x : S¹*) :
    smash_pcircle_of_psusp (psusp_of_smash_pcircle (smash.mk a x)) = smash.mk a x :=
  begin
    induction x,
    { exact gluel' pt a },
    { exact abstract begin apply eq_pathover,
      refine ap_compose smash_pcircle_of_psusp _ _ ⬝ph _,
      refine ap02 _ (elim_loop north (merid a ⬝ (merid pt)⁻¹)) ⬝ph _,
      refine !ap_con ⬝ (!elim_merid ◾ (!ap_inv ⬝ !elim_merid⁻²)) ⬝ph _,
      -- make everything below this a lemma defined by path induction?
      apply square_of_eq, rewrite [+con.assoc], apply whisker_left, apply whisker_left,
      symmetry, apply con_eq_of_eq_inv_con, esimp, apply con_eq_of_eq_con_inv,
      refine _⁻² ⬝ !con_inv, refine _ ⬝ !con.assoc,
      refine _ ⬝ whisker_right _ !inv_con_cancel_right⁻¹, refine _ ⬝ !con.right_inv⁻¹,
      refine !con.right_inv ◾ _, refine _ ◾ !con.right_inv,
      refine !ap_mk_right ⬝ !con.right_inv end end }
  end

  -- definition smash_pcircle_of_psusp_of_smash_pcircle_gluer_base (b : S¹*)
  --   : square (smash_pcircle_of_psusp_of_smash_pcircle_pt (Point A) b)
  --            (gluer pt)
  --            (ap smash_pcircle_of_psusp (ap (λ a, psusp_of_smash_pcircle a) (gluer b)))
  --            (gluer b) :=
  -- begin
  --   refine ap02 _ !elim_gluer ⬝ph _,
  --   induction b,
  --   { apply square_of_eq, exact whisker_right _ !con.right_inv },
  --   { apply square_pathover', exact sorry }
  -- end

exit
  definition smash_pcircle_pequiv [constructor] (A : Type*) : smash A S¹* ≃* psusp A :=
  begin
    fapply pequiv_of_equiv,
    { fapply equiv.MK,
      { exact psusp_of_smash_pcircle },
      { exact smash_pcircle_of_psusp },
      { exact abstract begin intro x, induction x,
        { reflexivity },
        { exact merid pt },
        { apply eq_pathover_id_right,
          refine ap_compose psusp_of_smash_pcircle _ _ ⬝ph _,
          refine ap02 _ !elim_merid ⬝ph _,
          rewrite [↑gluel', +ap_con, +ap_inv, -ap_compose'],
          refine (_ ◾ _⁻² ◾ _ ◾ (_ ◾ _⁻²)) ⬝ph _,
          rotate 5, do 2 (unfold [psusp_of_smash_pcircle]; apply elim_gluel),
          esimp, apply elim_loop, do 2 (unfold [psusp_of_smash_pcircle]; apply elim_gluel),
          refine idp_con (merid a ⬝ (merid (Point A))⁻¹) ⬝ph _,
          apply square_of_eq, refine !idp_con ⬝ _⁻¹, apply inv_con_cancel_right } end end },
      { intro x, induction x using smash.rec,
        { exact smash_pcircle_of_psusp_of_smash_pcircle_pt a b },
        { exact gluel pt },
        { exact gluer pt },
        { apply eq_pathover_id_right,
          refine ap_compose smash_pcircle_of_psusp _ _ ⬝ph _,
          unfold [psusp_of_smash_pcircle],
          refine ap02 _ !elim_gluel ⬝ph _,
          esimp, apply whisker_rt, exact vrfl },
        { apply eq_pathover_id_right,
          refine ap_compose smash_pcircle_of_psusp _ _ ⬝ph _,
          unfold [psusp_of_smash_pcircle],
          refine ap02 _ !elim_gluer ⬝ph _,
          induction b,
          { apply square_of_eq, exact whisker_right _ !con.right_inv },
          { exact sorry}
          }}},
    { reflexivity }
  end

end smash
-- (X × A) → Y ≃ X → A → Y
