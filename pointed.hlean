/- equalities between pointed homotopies -/

-- Author: Floris van Doorn

--import .pointed_pi

import .move_to_lib

open pointed eq equiv function is_equiv unit is_trunc trunc nat algebra group sigma

namespace pointed

  definition punit_pmap_phomotopy [constructor] {A : Type*} (f : punit →* A) : f ~* pconst punit A :=
  begin
    fapply phomotopy.mk,
    { intro u, induction u, exact respect_pt f },
    { reflexivity }
  end

  definition is_contr_punit_pmap (A : Type*) : is_contr (punit →* A) :=
    is_contr.mk (pconst punit A) (λf, eq_of_phomotopy (punit_pmap_phomotopy f)⁻¹*)

  definition phomotopy_of_eq_idp {A B : Type*} (f : A →* B) : phomotopy_of_eq idp = phomotopy.refl f :=
  idp

  definition to_fun_pequiv_trans {X Y Z : Type*} (f : X ≃* Y) (g :Y ≃* Z) : f ⬝e* g ~ g ∘ f :=
  λx, idp

  definition pr1_phomotopy_eq {A B : Type*} {f g : A →* B} {p q : f ~* g} (r : p = q) (a : A) :
    p a = q a :=
  ap010 to_homotopy r a

  definition ap1_gen_con_left {A B : Type} {a a' : A} {b₀ b₁ b₂ : B}
    {f : A → b₀ = b₁} {f' : A → b₁ = b₂} (p : a = a') {q₀ q₁ : b₀ = b₁} {q₀' q₁' : b₁ = b₂}
    (r₀ : f a = q₀) (r₁ : f a' = q₁) (r₀' : f' a = q₀') (r₁' : f' a' = q₁') :
      ap1_gen (λa, f a ⬝ f' a) p (r₀ ◾ r₀') (r₁ ◾ r₁') =
      whisker_right q₀' (ap1_gen f p r₀ r₁) ⬝ whisker_left q₁ (ap1_gen f' p r₀' r₁') :=
  begin induction r₀, induction r₁, induction r₀', induction r₁', induction p, reflexivity end

  definition ap1_gen_con_left_idp {A B : Type} {a : A} {b₀ b₁ b₂ : B}
    {f : A → b₀ = b₁} {f' : A → b₁ = b₂} {q₀ : b₀ = b₁} {q₁ : b₁ = b₂}
    (r₀ : f a = q₀) (r₁ : f' a = q₁) :
      ap1_gen_con_left idp r₀ r₀ r₁ r₁ =
      !con.left_inv ⬝ (ap (whisker_right q₁) !con.left_inv ◾ ap (whisker_left _) !con.left_inv)⁻¹ :=
  begin induction r₀, induction r₁, reflexivity end

  -- /- the pointed type of (unpointed) dependent maps -/
  -- definition pupi [constructor] {A : Type} (P : A → Type*) : Type* :=
  -- pointed.mk' (Πa, P a)

  -- definition loop_pupi_commute {A : Type} (B : A → Type*) : Ω(pupi B) ≃* pupi (λa, Ω (B a)) :=
  -- pequiv_of_equiv eq_equiv_homotopy rfl

  -- definition equiv_pupi_right {A : Type} {P Q : A → Type*} (g : Πa, P a ≃* Q a)
  --   : pupi P ≃* pupi Q :=
  -- pequiv_of_equiv (pi_equiv_pi_right g)
  --   begin esimp, apply eq_of_homotopy, intros a, esimp, exact (respect_pt (g a)) end

  section psquare
  /-
    Squares of pointed maps

    We treat expressions of the form
      psquare f g h k :≡ k ∘* f ~* g ∘* h
    as squares, where f is the top, g is the bottom, h is the left face and k is the right face.
    Then the following are operations on squares
  -/

  variables {A A' A₀₀ A₂₀ A₄₀ A₀₂ A₂₂ A₄₂ A₀₄ A₂₄ A₄₄ : Type*}
            {f₁₀ f₁₀' : A₀₀ →* A₂₀} {f₃₀ : A₂₀ →* A₄₀}
            {f₀₁ f₀₁' : A₀₀ →* A₀₂} {f₂₁ f₂₁' : A₂₀ →* A₂₂} {f₄₁ : A₄₀ →* A₄₂}
            {f₁₂ f₁₂' : A₀₂ →* A₂₂} {f₃₂ : A₂₂ →* A₄₂}
            {f₀₃ : A₀₂ →* A₀₄} {f₂₃ : A₂₂ →* A₂₄} {f₄₃ : A₄₂ →* A₄₄}
            {f₁₄ : A₀₄ →* A₂₄} {f₃₄ : A₂₄ →* A₄₄}

  definition psquare [reducible] (f₁₀ : A₀₀ →* A₂₀) (f₁₂ : A₀₂ →* A₂₂)
                                 (f₀₁ : A₀₀ →* A₀₂) (f₂₁ : A₂₀ →* A₂₂) : Type :=
  f₂₁ ∘* f₁₀ ~* f₁₂ ∘* f₀₁

  definition psquare_of_phomotopy (p : f₂₁ ∘* f₁₀ ~* f₁₂ ∘* f₀₁) : psquare f₁₀ f₁₂ f₀₁ f₂₁ :=
  p

  definition phomotopy_of_psquare (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) : f₂₁ ∘* f₁₀ ~* f₁₂ ∘* f₀₁ :=
  p

  definition phdeg_square {f f' : A →* A'} (p : f ~* f') : psquare !pid !pid f f' :=
  !pcompose_pid ⬝* p⁻¹* ⬝* !pid_pcompose⁻¹*
  definition pvdeg_square {f f' : A →* A'} (p : f ~* f') : psquare f f' !pid !pid :=
  !pid_pcompose ⬝* p ⬝* !pcompose_pid⁻¹*

  variables (f₀₁ f₁₀)
  definition phrefl : psquare !pid !pid f₀₁ f₀₁ := phdeg_square phomotopy.rfl
  definition pvrefl : psquare f₁₀ f₁₀ !pid !pid := pvdeg_square phomotopy.rfl
  variables {f₀₁ f₁₀}
  definition phrfl : psquare !pid !pid f₀₁ f₀₁ := phrefl f₀₁
  definition pvrfl : psquare f₁₀ f₁₀ !pid !pid := pvrefl f₁₀

  definition phconcat (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) (q : psquare f₃₀ f₃₂ f₂₁ f₄₁) :
    psquare (f₃₀ ∘* f₁₀) (f₃₂ ∘* f₁₂) f₀₁ f₄₁ :=
  !passoc⁻¹* ⬝* pwhisker_right f₁₀ q ⬝* !passoc ⬝* pwhisker_left f₃₂ p ⬝* !passoc⁻¹*

  definition pvconcat (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) (q : psquare f₁₂ f₁₄ f₀₃ f₂₃) :
    psquare f₁₀ f₁₄ (f₀₃ ∘* f₀₁) (f₂₃ ∘* f₂₁) :=
  !passoc ⬝* pwhisker_left _ p ⬝* !passoc⁻¹* ⬝* pwhisker_right _ q ⬝* !passoc

  definition phinverse {f₁₀ : A₀₀ ≃* A₂₀} {f₁₂ : A₀₂ ≃* A₂₂} (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare f₁₀⁻¹ᵉ* f₁₂⁻¹ᵉ* f₂₁ f₀₁ :=
  !pid_pcompose⁻¹* ⬝* pwhisker_right _ (pleft_inv f₁₂)⁻¹* ⬝* !passoc ⬝*
  pwhisker_left _
    (!passoc⁻¹* ⬝* pwhisker_right _ p⁻¹* ⬝* !passoc ⬝* pwhisker_left _ !pright_inv ⬝* !pcompose_pid)

  definition pvinverse {f₀₁ : A₀₀ ≃* A₀₂} {f₂₁ : A₂₀ ≃* A₂₂} (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare f₁₂ f₁₀ f₀₁⁻¹ᵉ* f₂₁⁻¹ᵉ* :=
  (phinverse p⁻¹*)⁻¹*

  definition phomotopy_hconcat (q : f₀₁' ~* f₀₁) (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare f₁₀ f₁₂ f₀₁' f₂₁ :=
  p ⬝* pwhisker_left f₁₂ q⁻¹*

  definition hconcat_phomotopy (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) (q : f₂₁' ~* f₂₁) :
    psquare f₁₀ f₁₂ f₀₁ f₂₁' :=
  pwhisker_right f₁₀ q ⬝* p

  definition phomotopy_vconcat (q : f₁₀' ~* f₁₀) (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare f₁₀' f₁₂ f₀₁ f₂₁ :=
  pwhisker_left f₂₁ q ⬝* p

  definition vconcat_phomotopy (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) (q : f₁₂' ~* f₁₂) :
    psquare f₁₀ f₁₂' f₀₁ f₂₁ :=
  p ⬝* pwhisker_right f₀₁ q⁻¹*

  infix ` ⬝h* `:73 := phconcat
  infix ` ⬝v* `:73 := pvconcat
  infixl ` ⬝hp* `:72 := hconcat_phomotopy
  infixr ` ⬝ph* `:72 := phomotopy_hconcat
  infixl ` ⬝vp* `:72 := vconcat_phomotopy
  infixr ` ⬝pv* `:72 := phomotopy_vconcat
  postfix `⁻¹ʰ*`:(max+1) := phinverse
  postfix `⁻¹ᵛ*`:(max+1) := pvinverse

  definition ap1_psquare (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare (Ω→ f₁₀) (Ω→ f₁₂) (Ω→ f₀₁) (Ω→ f₂₁) :=
  !ap1_pcompose⁻¹* ⬝* ap1_phomotopy p ⬝* !ap1_pcompose

  definition apn_psquare (n : ℕ) (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare (Ω→[n] f₁₀) (Ω→[n] f₁₂) (Ω→[n] f₀₁) (Ω→[n] f₂₁) :=
  !apn_pcompose⁻¹* ⬝* apn_phomotopy n p ⬝* !apn_pcompose

  definition ptrunc_functor_psquare (n : ℕ₋₂) (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare (ptrunc_functor n f₁₀) (ptrunc_functor n f₁₂)
            (ptrunc_functor n f₀₁) (ptrunc_functor n f₂₁) :=
  !ptrunc_functor_pcompose⁻¹* ⬝* ptrunc_functor_phomotopy n p ⬝* !ptrunc_functor_pcompose

  definition homotopy_group_functor_psquare (n : ℕ) (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
        psquare (π→[n] f₁₀) (π→[n] f₁₂) (π→[n] f₀₁) (π→[n] f₂₁) :=
  !homotopy_group_functor_compose⁻¹* ⬝* homotopy_group_functor_phomotopy n p ⬝*
  !homotopy_group_functor_compose

  definition homotopy_group_homomorphism_psquare (n : ℕ) [H : is_succ n]
    (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) : hsquare (π→g[n] f₁₀) (π→g[n] f₁₂) (π→g[n] f₀₁) (π→g[n] f₂₁) :=
  begin
    induction H with n, exact to_homotopy (ptrunc_functor_psquare 0 (apn_psquare (succ n) p))
  end

  end psquare

  definition phomotopy_of_eq_of_phomotopy {A B : Type*} {f g : A →* B} (p : f ~* g) :
    phomotopy_of_eq (eq_of_phomotopy p) = p :=
  to_right_inv (pmap_eq_equiv f g) p

  definition ap_eq_of_phomotopy {A B : Type*} {f g : A →* B} (p : f ~* g) (a : A) :
    ap (λf : A →* B, f a) (eq_of_phomotopy p) = p a :=
  ap010 to_homotopy (phomotopy_of_eq_of_phomotopy p) a

  definition phomotopy_rec_on_eq [recursor] {A B : Type*} {f g : A →* B}
    {Q : (f ~* g) → Type} (p : f ~* g) (H : Π(q : f = g), Q (phomotopy_of_eq q)) : Q p :=
  phomotopy_of_eq_of_phomotopy p ▸ H (eq_of_phomotopy p)

  definition phomotopy_rec_on_idp [recursor] {A B : Type*} {f : A →* B}
    {Q : Π{g}, (f ~* g) → Type} {g : A →* B} (p : f ~* g) (H : Q (phomotopy.refl f)) : Q p :=
  begin
    induction p using phomotopy_rec_on_eq,
    induction q, exact H
  end

  definition phomotopy_rec_on_eq_phomotopy_of_eq {A B : Type*} {f g: A →* B}
    {Q : (f ~* g) → Type} (p : f = g) (H : Π(q : f = g), Q (phomotopy_of_eq q)) :
    phomotopy_rec_on_eq (phomotopy_of_eq p) H = H p :=
  begin
    unfold phomotopy_rec_on_eq,
    refine ap (λp, p ▸ _) !adj ⬝ _,
    refine !tr_compose⁻¹ ⬝ _,
    apply apdt
  end

  definition phomotopy_rec_on_idp_refl {A B : Type*} (f : A →* B)
    {Q : Π{g}, (f ~* g) → Type} (H : Q (phomotopy.refl f)) :
    phomotopy_rec_on_idp phomotopy.rfl H = H :=
  !phomotopy_rec_on_eq_phomotopy_of_eq

  definition phomotopy_eq_equiv {A B : Type*} {f g : A →* B} (h k : f ~* g) :
    (h = k) ≃ Σ(p : to_homotopy h ~ to_homotopy k),
      whisker_right (respect_pt g) (p pt) ⬝ to_homotopy_pt k = to_homotopy_pt h :=
  calc
    h = k ≃ phomotopy.sigma_char _ _ h = phomotopy.sigma_char _ _ k
      : eq_equiv_fn_eq (phomotopy.sigma_char f g) h k
      ... ≃ Σ(p : to_homotopy h = to_homotopy k),
              pathover (λp, p pt ⬝ respect_pt g = respect_pt f) (to_homotopy_pt h) p (to_homotopy_pt k)
      : sigma_eq_equiv _ _
      ... ≃ Σ(p : to_homotopy h = to_homotopy k),
              to_homotopy_pt h = ap (λq, q pt ⬝ respect_pt g) p ⬝ to_homotopy_pt k
      : sigma_equiv_sigma_right (λp, eq_pathover_equiv_Fl p (to_homotopy_pt h) (to_homotopy_pt k))
      ... ≃ Σ(p : to_homotopy h = to_homotopy k),
              ap (λq, q pt ⬝ respect_pt g) p ⬝ to_homotopy_pt k = to_homotopy_pt h
      : sigma_equiv_sigma_right (λp, eq_equiv_eq_symm _ _)
      ... ≃ Σ(p : to_homotopy h = to_homotopy k),
      whisker_right (respect_pt g) (apd10 p pt) ⬝ to_homotopy_pt k = to_homotopy_pt h
      : sigma_equiv_sigma_right (λp, equiv_eq_closed_left _ (whisker_right _ !whisker_right_ap⁻¹))
      ... ≃ Σ(p : to_homotopy h ~ to_homotopy k),
      whisker_right (respect_pt g) (p pt) ⬝ to_homotopy_pt k = to_homotopy_pt h
      : sigma_equiv_sigma_left' eq_equiv_homotopy

  definition phomotopy_eq {A B : Type*} {f g : A →* B} {h k : f ~* g} (p : to_homotopy h ~ to_homotopy k)
    (q : whisker_right (respect_pt g) (p pt) ⬝ to_homotopy_pt k = to_homotopy_pt h) : h = k :=
  to_inv (phomotopy_eq_equiv h k) ⟨p, q⟩

  definition phomotopy_eq' {A B : Type*} {f g : A →* B} {h k : f ~* g} (p : to_homotopy h ~ to_homotopy k)
    (q : square (to_homotopy_pt h) (to_homotopy_pt k) (whisker_right (respect_pt g) (p pt)) idp) : h = k :=
  phomotopy_eq p (eq_of_square q)⁻¹

  definition eq_of_phomotopy_refl {X Y : Type*} (f : X →* Y) :
    eq_of_phomotopy (phomotopy.refl f) = idpath f :=
  begin
    apply to_inv_eq_of_eq, reflexivity
  end

  definition trans_refl {A B : Type*} {f g : A →* B} (p : f ~* g) : p ⬝* phomotopy.refl g = p :=
  begin
    induction A with A a₀, induction B with B b₀,
    induction f with f f₀, induction g with g g₀, induction p with p p₀,
    esimp at *, induction g₀, induction p₀,
    reflexivity
  end

  definition eq_of_phomotopy_trans {X Y : Type*} {f g h : X →* Y} (p : f ~* g) (q : g ~* h) :
    eq_of_phomotopy (p ⬝* q) = eq_of_phomotopy p ⬝ eq_of_phomotopy q :=
  begin
    induction p using phomotopy_rec_on_idp, induction q using phomotopy_rec_on_idp,
    exact ap eq_of_phomotopy !trans_refl ⬝ whisker_left _ !eq_of_phomotopy_refl⁻¹
  end

  definition refl_trans {A B : Type*} {f g : A →* B} (p : f ~* g) : phomotopy.refl f ⬝* p = p :=
  begin
    induction p using phomotopy_rec_on_idp,
    induction A with A a₀, induction B with B b₀,
    induction f with f f₀, esimp at *, induction f₀,
    reflexivity
  end

  definition trans_assoc {A B : Type*} {f g h i : A →* B} (p : f ~* g) (q : g ~* h)
    (r : h ~* i) : p ⬝* q ⬝* r = p ⬝* (q ⬝* r) :=
  begin
    induction r using phomotopy_rec_on_idp,
    induction q using phomotopy_rec_on_idp,
    induction p using phomotopy_rec_on_idp,
    induction B with B b₀,
    induction f with f f₀, esimp at *, induction f₀,
    reflexivity
  end

  definition refl_symm {A B : Type*} (f : A →* B) : phomotopy.rfl⁻¹* = phomotopy.refl f :=
  begin
    induction B with B b₀,
    induction f with f f₀, esimp at *, induction f₀,
    reflexivity
  end

  definition symm_symm {A B : Type*} {f g : A →* B} (p : f ~* g) : p⁻¹*⁻¹* = p :=
  phomotopy_eq (λa, !inv_inv)
    begin
      induction p using phomotopy_rec_on_idp, induction f with f f₀, induction B with B b₀,
      esimp at *, induction f₀, reflexivity
    end

  definition trans_right_inv {A B : Type*} {f g : A →* B} (p : f ~* g) : p ⬝* p⁻¹* = phomotopy.rfl :=
  begin
    induction p using phomotopy_rec_on_idp, exact !refl_trans ⬝ !refl_symm
  end

  definition trans_left_inv {A B : Type*} {f g : A →* B} (p : f ~* g) : p⁻¹* ⬝* p = phomotopy.rfl :=
  begin
    induction p using phomotopy_rec_on_idp, exact !trans_refl ⬝ !refl_symm
  end

  definition trans2 {A B : Type*} {f g h : A →* B} {p p' : f ~* g} {q q' : g ~* h}
    (r : p = p') (s : q = q') : p ⬝* q = p' ⬝* q' :=
  ap011 phomotopy.trans r s

  definition pcompose3 {A B C : Type*} {g g' : B →* C} {f f' : A →* B}
  {p p' : g ~* g'} {q q' : f ~* f'} (r : p = p') (s : q = q') : p ◾* q = p' ◾* q' :=
  ap011 pcompose2 r s

  definition symm2 {A B : Type*} {f g : A →* B} {p p' : f ~* g} (r : p = p') : p⁻¹* = p'⁻¹* :=
  ap phomotopy.symm r

  infixl ` ◾** `:80 := pointed.trans2
  infixl ` ◽* `:81 := pointed.pcompose3
  postfix `⁻²**`:(max+1) := pointed.symm2

  definition trans_symm {A B : Type*} {f g h : A →* B} (p : f ~* g) (q : g ~* h) :
    (p ⬝* q)⁻¹* = q⁻¹* ⬝* p⁻¹* :=
  begin
    induction p using phomotopy_rec_on_idp, induction q using phomotopy_rec_on_idp,
    exact !trans_refl⁻²** ⬝ !trans_refl⁻¹ ⬝ idp ◾** !refl_symm⁻¹
  end

  definition phwhisker_left {A B : Type*} {f g h : A →* B} (p : f ~* g) {q q' : g ~* h}
    (s : q = q') : p ⬝* q = p ⬝* q' :=
  idp ◾** s

  definition phwhisker_right {A B : Type*} {f g h : A →* B} {p p' : f ~* g} (q : g ~* h)
    (r : p = p') : p ⬝* q = p' ⬝* q :=
  r ◾** idp

  definition pwhisker_left_refl {A B C : Type*} (g : B →* C) (f : A →* B) :
    pwhisker_left g (phomotopy.refl f) = phomotopy.refl (g ∘* f) :=
  begin
    induction A with A a₀, induction B with B b₀, induction C with C c₀,
    induction f with f f₀, induction g with g g₀,
    esimp at *, induction g₀, induction f₀, reflexivity
  end

  definition pwhisker_right_refl {A B C : Type*} (f : A →* B) (g : B →* C) :
    pwhisker_right f (phomotopy.refl g) = phomotopy.refl (g ∘* f) :=
  begin
    induction A with A a₀, induction B with B b₀, induction C with C c₀,
    induction f with f f₀, induction g with g g₀,
    esimp at *, induction g₀, induction f₀, reflexivity
  end

  definition pcompose2_refl {A B C : Type*} (g : B →* C) (f : A →* B) :
    phomotopy.refl g ◾* phomotopy.refl f = phomotopy.rfl :=
  !pwhisker_right_refl ◾** !pwhisker_left_refl ⬝ !refl_trans

  definition pcompose2_refl_left {A B C : Type*} (g : B →* C) {f f' : A →* B} (p : f ~* f') :
    phomotopy.rfl ◾* p = pwhisker_left g p :=
  !pwhisker_right_refl ◾** idp ⬝ !refl_trans

  definition pcompose2_refl_right {A B C : Type*} {g g' : B →* C} (f : A →* B) (p : g ~* g') :
    p ◾* phomotopy.rfl = pwhisker_right f p :=
  idp ◾** !pwhisker_left_refl ⬝ !trans_refl

  definition pwhisker_left_trans {A B C : Type*} (g : B →* C) {f₁ f₂ f₃ : A →* B}
    (p : f₁ ~* f₂) (q : f₂ ~* f₃) :
    pwhisker_left g (p ⬝* q) = pwhisker_left g p ⬝* pwhisker_left g q :=
  begin
    induction p using phomotopy_rec_on_idp,
    induction q using phomotopy_rec_on_idp,
    refine _ ⬝ !pwhisker_left_refl⁻¹ ◾** !pwhisker_left_refl⁻¹,
    refine ap (pwhisker_left g) !trans_refl ⬝ !pwhisker_left_refl ⬝ !trans_refl⁻¹
  end

  definition pwhisker_right_trans {A B C : Type*} (f : A →* B) {g₁ g₂ g₃ : B →* C}
    (p : g₁ ~* g₂) (q : g₂ ~* g₃) :
    pwhisker_right f (p ⬝* q) = pwhisker_right f p ⬝* pwhisker_right f q :=
  begin
    induction p using phomotopy_rec_on_idp,
    induction q using phomotopy_rec_on_idp,
    refine _ ⬝ !pwhisker_right_refl⁻¹ ◾** !pwhisker_right_refl⁻¹,
    refine ap (pwhisker_right f) !trans_refl ⬝ !pwhisker_right_refl ⬝ !trans_refl⁻¹
  end

  definition pwhisker_left_symm {A B C : Type*} (g : B →* C) {f₁ f₂ : A →* B} (p : f₁ ~* f₂) :
    pwhisker_left g p⁻¹* = (pwhisker_left g p)⁻¹* :=
  begin
    induction p using phomotopy_rec_on_idp,
    refine _ ⬝ ap phomotopy.symm !pwhisker_left_refl⁻¹,
    refine ap (pwhisker_left g) !refl_symm ⬝ !pwhisker_left_refl ⬝ !refl_symm⁻¹
  end

  definition pwhisker_right_symm {A B C : Type*} (f : A →* B) {g₁ g₂ : B →* C} (p : g₁ ~* g₂) :
    pwhisker_right f p⁻¹* = (pwhisker_right f p)⁻¹* :=
  begin
    induction p using phomotopy_rec_on_idp,
    refine _ ⬝ ap phomotopy.symm !pwhisker_right_refl⁻¹,
    refine ap (pwhisker_right f) !refl_symm ⬝ !pwhisker_right_refl ⬝ !refl_symm⁻¹
  end

  definition trans_eq_of_eq_symm_trans {A B : Type*} {f g h : A →* B} {p : f ~* g} {q : g ~* h}
    {r : f ~* h} (s : q = p⁻¹* ⬝* r) : p ⬝* q = r :=
  idp ◾** s ⬝ !trans_assoc⁻¹ ⬝ trans_right_inv p ◾** idp ⬝ !refl_trans

  definition eq_symm_trans_of_trans_eq {A B : Type*} {f g h : A →* B} {p : f ~* g} {q : g ~* h}
    {r : f ~* h} (s : p ⬝* q = r) : q = p⁻¹* ⬝* r :=
  !refl_trans⁻¹ ⬝ !trans_left_inv⁻¹ ◾** idp ⬝ !trans_assoc ⬝ idp ◾** s

  definition trans_eq_of_eq_trans_symm {A B : Type*} {f g h : A →* B} {p : f ~* g} {q : g ~* h}
    {r : f ~* h} (s : p = r ⬝* q⁻¹*) : p ⬝* q = r :=
  s ◾** idp ⬝ !trans_assoc ⬝ idp ◾** trans_left_inv q ⬝ !trans_refl

  definition eq_trans_symm_of_trans_eq {A B : Type*} {f g h : A →* B} {p : f ~* g} {q : g ~* h}
    {r : f ~* h} (s : p ⬝* q = r) : p = r ⬝* q⁻¹* :=
  !trans_refl⁻¹ ⬝ idp ◾** !trans_right_inv⁻¹ ⬝ !trans_assoc⁻¹ ⬝ s ◾** idp

  section phsquare
  /-
    Squares of pointed homotopies
  -/

  variables {A B C : Type*} {f f' f₀₀ f₂₀ f₄₀ f₀₂ f₂₂ f₄₂ f₀₄ f₂₄ f₄₄ : A →* B}
            {p₁₀ : f₀₀ ~* f₂₀} {p₃₀ : f₂₀ ~* f₄₀}
            {p₀₁ : f₀₀ ~* f₀₂} {p₂₁ : f₂₀ ~* f₂₂} {p₄₁ : f₄₀ ~* f₄₂}
            {p₁₂ : f₀₂ ~* f₂₂} {p₃₂ : f₂₂ ~* f₄₂}
            {p₀₃ : f₀₂ ~* f₀₄} {p₂₃ : f₂₂ ~* f₂₄} {p₄₃ : f₄₂ ~* f₄₄}
            {p₁₄ : f₀₄ ~* f₂₄} {p₃₄ : f₂₄ ~* f₄₄}

  definition phsquare [reducible] (p₁₀ : f₀₀ ~* f₂₀) (p₁₂ : f₀₂ ~* f₂₂)
                                  (p₀₁ : f₀₀ ~* f₀₂) (p₂₁ : f₂₀ ~* f₂₂) : Type :=
  p₁₀ ⬝* p₂₁ = p₀₁ ⬝* p₁₂

  definition phsquare_of_eq (p : p₁₀ ⬝* p₂₁ = p₀₁ ⬝* p₁₂) : phsquare p₁₀ p₁₂ p₀₁ p₂₁ := p
  definition eq_of_phsquare (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) : p₁₀ ⬝* p₂₁ = p₀₁ ⬝* p₁₂ := p

  definition phhconcat (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) (q : phsquare p₃₀ p₃₂ p₂₁ p₄₁) :
    phsquare (p₁₀ ⬝* p₃₀) (p₁₂ ⬝* p₃₂) p₀₁ p₄₁ :=
  !trans_assoc ⬝ idp ◾** q ⬝ !trans_assoc⁻¹ ⬝ p ◾** idp ⬝ !trans_assoc

  definition phvconcat (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) (q : phsquare p₁₂ p₁₄ p₀₃ p₂₃) :
    phsquare p₁₀ p₁₄ (p₀₁ ⬝* p₀₃) (p₂₁ ⬝* p₂₃) :=
  (phhconcat p⁻¹ q⁻¹)⁻¹

  definition phhdeg_square {p₁ p₂ : f ~* f'} (q : p₁ = p₂) : phsquare phomotopy.rfl phomotopy.rfl p₁ p₂ :=
  !refl_trans ⬝ q⁻¹ ⬝ !trans_refl⁻¹
  definition phvdeg_square {p₁ p₂ : f ~* f'} (q : p₁ = p₂) : phsquare p₁ p₂ phomotopy.rfl phomotopy.rfl :=
  !trans_refl ⬝ q ⬝ !refl_trans⁻¹

  variables (p₀₁ p₁₀)
  definition phhrefl : phsquare phomotopy.rfl phomotopy.rfl p₀₁ p₀₁ := phhdeg_square idp
  definition phvrefl : phsquare p₁₀ p₁₀ phomotopy.rfl phomotopy.rfl := phvdeg_square idp
  variables {p₀₁ p₁₀}
  definition phhrfl : phsquare phomotopy.rfl phomotopy.rfl p₀₁ p₀₁ := phhrefl p₀₁
  definition phvrfl : phsquare p₁₀ p₁₀ phomotopy.rfl phomotopy.rfl := phvrefl p₁₀

  /-
    The names are very baroque. The following stands for
    "pointed homotopy path-horizontal composition" (i.e. composition on the left with a path)
    The names are obtained by using the ones for squares, and putting "ph" in front of it.
    In practice, use the notation ⬝ph** defined below, which might be easier to remember
  -/
  definition phphconcat {p₀₁'} (p : p₀₁' = p₀₁) (q : phsquare p₁₀ p₁₂ p₀₁ p₂₁) :
    phsquare p₁₀ p₁₂ p₀₁' p₂₁ :=
  by induction p; exact q

  definition phhpconcat {p₂₁'} (q : phsquare p₁₀ p₁₂ p₀₁ p₂₁) (p : p₂₁ = p₂₁') :
    phsquare p₁₀ p₁₂ p₀₁ p₂₁' :=
  by induction p; exact q

  definition phpvconcat {p₁₀'} (p : p₁₀' = p₁₀) (q : phsquare p₁₀ p₁₂ p₀₁ p₂₁) :
    phsquare p₁₀' p₁₂ p₀₁ p₂₁ :=
  by induction p; exact q

  definition phvpconcat {p₁₂'} (q : phsquare p₁₀ p₁₂ p₀₁ p₂₁) (p : p₁₂ = p₁₂') :
    phsquare p₁₀ p₁₂' p₀₁ p₂₁ :=
  by induction p; exact q

  definition phhinverse (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) : phsquare p₁₀⁻¹* p₁₂⁻¹* p₂₁ p₀₁ :=
  begin
    refine (eq_symm_trans_of_trans_eq _)⁻¹,
    refine !trans_assoc⁻¹ ⬝ _,
    refine (eq_trans_symm_of_trans_eq _)⁻¹,
    exact (eq_of_phsquare p)⁻¹
  end

  definition phvinverse (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) : phsquare p₁₂ p₁₀ p₀₁⁻¹* p₂₁⁻¹* :=
  (phhinverse p⁻¹)⁻¹

  infix ` ⬝h** `:78 := phhconcat
  infix ` ⬝v** `:78 := phvconcat
  infixr ` ⬝ph** `:77 := phphconcat
  infixl ` ⬝hp** `:77 := phhpconcat
  infixr ` ⬝pv** `:77 := phpvconcat
  infixl ` ⬝vp** `:77 := phvpconcat
  postfix `⁻¹ʰ**`:(max+1) := phhinverse
  postfix `⁻¹ᵛ**`:(max+1) := phvinverse

  definition phwhisker_rt (p : f ~* f₂₀) (q : phsquare p₁₀ p₁₂ p₀₁ p₂₁) :
    phsquare (p₁₀ ⬝* p⁻¹*) p₁₂ p₀₁ (p ⬝* p₂₁) :=
  !trans_assoc ⬝ idp ◾** (!trans_assoc⁻¹ ⬝ !trans_left_inv ◾** idp ⬝ !refl_trans) ⬝ q

  definition phwhisker_br (p : f₂₂ ~* f) (q : phsquare p₁₀ p₁₂ p₀₁ p₂₁) :
    phsquare p₁₀ (p₁₂ ⬝* p) p₀₁ (p₂₁ ⬝* p) :=
  !trans_assoc⁻¹ ⬝ q ◾** idp ⬝ !trans_assoc

  definition phmove_top_of_left' {p₀₁ : f ~* f₀₂} (p : f₀₀ ~* f)
    (q : phsquare p₁₀ p₁₂ (p ⬝* p₀₁) p₂₁) : phsquare (p⁻¹* ⬝* p₁₀) p₁₂ p₀₁ p₂₁ :=
  !trans_assoc ⬝ (eq_symm_trans_of_trans_eq (q ⬝ !trans_assoc)⁻¹)⁻¹

  definition passoc_phomotopy_right {A B C D : Type*} (h : C →* D) (g : B →* C) {f f' : A →* B}
    (p : f ~* f') : phsquare (passoc h g f) (passoc h g f')
      (pwhisker_left (h ∘* g) p) (pwhisker_left h (pwhisker_left g p)) :=
  begin
    induction p using phomotopy_rec_on_idp,
    refine idp ◾** (ap (pwhisker_left h) !pwhisker_left_refl ⬝ !pwhisker_left_refl) ⬝ _ ⬝
          !pwhisker_left_refl⁻¹ ◾** idp,
    exact !trans_refl ⬝ !refl_trans⁻¹
  end

  theorem passoc_phomotopy_middle {A B C D : Type*} (h : C →* D) {g g' : B →* C} (f : A →* B)
    (p : g ~* g') : phsquare (passoc h g f) (passoc h g' f)
      (pwhisker_right f (pwhisker_left h p)) (pwhisker_left h (pwhisker_right f p)) :=
  begin
    induction p using phomotopy_rec_on_idp,
    rewrite [pwhisker_right_refl, pwhisker_left_refl],
    rewrite [pwhisker_right_refl, pwhisker_left_refl],
    exact phvrfl
  end

  definition pwhisker_right_pwhisker_left {A B C : Type*} {g g' : B →* C} {f f' : A →* B}
    (p : g ~* g') (q : f ~* f') :
    phsquare (pwhisker_right f p) (pwhisker_right f' p) (pwhisker_left g q) (pwhisker_left g' q) :=
  begin
    induction p using phomotopy_rec_on_idp,
    induction q using phomotopy_rec_on_idp,
    exact !pwhisker_right_refl ◾** !pwhisker_left_refl ⬝
          !pwhisker_left_refl⁻¹ ◾** !pwhisker_right_refl⁻¹
  end

  definition pwhisker_left_phsquare (f : B →* C) (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) :
    phsquare (pwhisker_left f p₁₀) (pwhisker_left f p₁₂)
             (pwhisker_left f p₀₁) (pwhisker_left f p₂₁) :=
  !pwhisker_left_trans⁻¹ ⬝ ap (pwhisker_left f) p ⬝ !pwhisker_left_trans

  definition pwhisker_right_phsquare (f : C →* A) (p : phsquare p₁₀ p₁₂ p₀₁ p₂₁) :
    phsquare (pwhisker_right f p₁₀) (pwhisker_right f p₁₂)
             (pwhisker_right f p₀₁) (pwhisker_right f p₂₁) :=
  !pwhisker_right_trans⁻¹ ⬝ ap (pwhisker_right f) p ⬝ !pwhisker_right_trans

  end phsquare

  definition phomotopy_of_eq_con {A B : Type*} {f g h : A →* B} (p : f = g) (q : g = h) :
    phomotopy_of_eq (p ⬝ q) = phomotopy_of_eq p ⬝* phomotopy_of_eq q :=
  begin induction q, induction p, exact !trans_refl⁻¹ end

  definition pcompose_left_eq_of_phomotopy {A B C : Type*} (g : B →* C) {f f' : A →* B}
    (H : f ~* f') : ap (λf, g ∘* f) (eq_of_phomotopy H) = eq_of_phomotopy (pwhisker_left g H) :=
  begin
    induction H using phomotopy_rec_on_idp,
    refine ap02 _ !eq_of_phomotopy_refl ⬝ !eq_of_phomotopy_refl⁻¹ ⬝ ap eq_of_phomotopy _,
    exact !pwhisker_left_refl⁻¹
  end

  definition pcompose_right_eq_of_phomotopy {A B C : Type*} {g g' : B →* C} (f : A →* B)
    (H : g ~* g') : ap (λg, g ∘* f) (eq_of_phomotopy H) = eq_of_phomotopy (pwhisker_right f H) :=
  begin
    induction H using phomotopy_rec_on_idp,
    refine ap02 _ !eq_of_phomotopy_refl ⬝ !eq_of_phomotopy_refl⁻¹ ⬝ ap eq_of_phomotopy _,
    exact !pwhisker_right_refl⁻¹
  end

  definition to_fun_eq_of_phomotopy {A B : Type*} {f g : A →* B} (p : f ~* g) (a : A) :
    ap010 pmap.to_fun (eq_of_phomotopy p) a = p a :=
  begin
    induction p using phomotopy_rec_on_idp,
    exact ap (λx, ap010 pmap.to_fun x a) !eq_of_phomotopy_refl
  end

  definition respect_pt_pcompose {A B C : Type*} (g : B →* C) (f : A →* B)
    : respect_pt (g ∘* f) = ap g (respect_pt f) ⬝ respect_pt g :=
  idp

  definition phomotopy_mk_ppmap [constructor] {A B C : Type*} {f g : A →* ppmap B C} (p : Πa, f a ~* g a)
    (q : p pt ⬝* phomotopy_of_eq (respect_pt g) = phomotopy_of_eq (respect_pt f))
    : f ~* g :=
  begin
    apply phomotopy.mk (λa, eq_of_phomotopy (p a)),
    apply eq_of_fn_eq_fn (pmap_eq_equiv _ _), esimp [pmap_eq_equiv],
    refine !phomotopy_of_eq_con ⬝ _,
    refine !phomotopy_of_eq_of_phomotopy ◾** idp ⬝ q,
  end

  definition pconst_pcompose_pconst (A B C : Type*) :
    pconst_pcompose (pconst A B) = pcompose_pconst (pconst B C) :=
  idp

  definition pconst_pcompose_phomotopy_pconst {A B C : Type*} {f : A →* B} (p : f ~* pconst A B) :
    pconst_pcompose f = pwhisker_left (pconst B C) p ⬝* pcompose_pconst (pconst B C) :=
  begin
    assert H : Π(p : pconst A B ~* f),
      pconst_pcompose f = pwhisker_left (pconst B C) p⁻¹* ⬝* pcompose_pconst (pconst B C),
    { intro p, induction p using phomotopy_rec_on_idp, reflexivity },
    refine H p⁻¹* ⬝ ap (pwhisker_left _) !symm_symm ◾** idp,
  end

  definition passoc_pconst_right {A B C D : Type*} (h : C →* D) (g : B →* C) :
    passoc h g (pconst A B) ⬝* (pwhisker_left h (pcompose_pconst g) ⬝* pcompose_pconst h) =
    pcompose_pconst (h ∘* g) :=
  begin
    fapply phomotopy_eq,
    { intro a, exact !idp_con },
    { induction h with h h₀, induction g with g g₀, induction D with D d₀, induction C with C c₀,
      esimp at *, induction g₀, induction h₀, reflexivity }
  end

  definition passoc_pconst_middle {A A' B B' : Type*} (g : B →* B') (f : A' →* A) :
    passoc g (pconst A B) f ⬝* (pwhisker_left g (pconst_pcompose f) ⬝* pcompose_pconst g) =
    pwhisker_right f (pcompose_pconst g) ⬝* pconst_pcompose f :=
  begin
    fapply phomotopy_eq,
    { intro a, esimp, exact !idp_con ⬝ !idp_con },
    { induction g with g g₀, induction f with f f₀, induction B' with D d₀, induction A with C c₀,
      esimp at *, induction g₀, induction f₀, reflexivity }
  end

  definition ppcompose_left_pcompose [constructor] {A B C D : Type*} (h : C →* D) (g : B →* C) :
    @ppcompose_left A _ _ (h ∘* g) ~* ppcompose_left h ∘* ppcompose_left g :=
  begin
    fapply phomotopy_mk_ppmap,
    { exact passoc h g },
    { esimp,
      refine idp ◾** (!phomotopy_of_eq_con ⬝
        (ap phomotopy_of_eq !pcompose_left_eq_of_phomotopy ⬝ !phomotopy_of_eq_of_phomotopy) ◾**
        !phomotopy_of_eq_of_phomotopy) ⬝ _ ⬝ !phomotopy_of_eq_of_phomotopy⁻¹,
      exact passoc_pconst_right h g }
  end

  definition ppcompose_left_ppcompose_right {A A' B B' : Type*} (g : B →* B') (f : A' →* A) :
    psquare (ppcompose_left g) (ppcompose_left g) (ppcompose_right f) (ppcompose_right f) :=
  begin
    fapply phomotopy_mk_ppmap,
    { intro h, exact passoc g h f },
    { refine idp ◾** (!phomotopy_of_eq_con ⬝
        (ap phomotopy_of_eq !pcompose_left_eq_of_phomotopy ⬝ !phomotopy_of_eq_of_phomotopy) ◾**
        !phomotopy_of_eq_of_phomotopy) ⬝ _ ⬝ (!phomotopy_of_eq_con ⬝
        (ap phomotopy_of_eq !pcompose_right_eq_of_phomotopy ⬝ !phomotopy_of_eq_of_phomotopy) ◾**
        !phomotopy_of_eq_of_phomotopy)⁻¹,
      apply passoc_pconst_middle }
  end

  definition pcompose_pconst_phomotopy {A B C : Type*} {f f' : B →* C} (p : f ~* f') :
    pwhisker_right (pconst A B) p ⬝* pcompose_pconst f' = pcompose_pconst f :=
  begin
    fapply phomotopy_eq,
    { intro a, exact to_homotopy_pt p },
    { induction p using phomotopy_rec_on_idp, induction C with C c₀, induction f with f f₀,
      esimp at *, induction f₀, reflexivity }
  end

  definition pid_pconst (A B : Type*) : pcompose_pconst (pid B) = pid_pcompose (pconst A B) :=
  by reflexivity

  definition pid_pconst_pcompose {A B C : Type*} (f : A →* B) :
    phsquare (pid_pcompose (pconst B C ∘* f))
             (pcompose_pconst (pid C))
             (pwhisker_left (pid C) (pconst_pcompose f))
             (pconst_pcompose f) :=
  begin
    fapply phomotopy_eq,
    { reflexivity },
    { induction f with f f₀, induction B with B b₀, esimp at *, induction f₀, reflexivity }
  end

  definition ppcompose_left_pconst [constructor] (A B C : Type*) :
    @ppcompose_left A _ _ (pconst B C) ~* pconst (ppmap A B) (ppmap A C) :=
  begin
    fapply phomotopy_mk_ppmap,
    { exact pconst_pcompose },
    { refine idp ◾** !phomotopy_of_eq_idp ⬝ !phomotopy_of_eq_of_phomotopy⁻¹ }
  end

  definition ppcompose_left_phomotopy [constructor] {A B C : Type*} {g g' : B →* C} (p : g ~* g') :
    @ppcompose_left A _ _ g ~* ppcompose_left g' :=
  begin
    induction p using phomotopy_rec_on_idp,
    reflexivity
  end

  section psquare

  variables {A A' A₀₀ A₂₀ A₄₀ A₀₂ A₂₂ A₄₂ A₀₄ A₂₄ A₄₄ : Type*}
            {f₁₀ f₁₀' : A₀₀ →* A₂₀} {f₃₀ : A₂₀ →* A₄₀}
            {f₀₁ f₀₁' : A₀₀ →* A₀₂} {f₂₁ f₂₁' : A₂₀ →* A₂₂} {f₄₁ : A₄₀ →* A₄₂}
            {f₁₂ f₁₂' : A₀₂ →* A₂₂} {f₃₂ : A₂₂ →* A₄₂}
            {f₀₃ : A₀₂ →* A₀₄} {f₂₃ : A₂₂ →* A₂₄} {f₄₃ : A₄₂ →* A₄₄}
            {f₁₄ : A₀₄ →* A₂₄} {f₃₄ : A₂₄ →* A₄₄}

  definition ppcompose_left_psquare {A : Type*} (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    psquare (@ppcompose_left A _ _ f₁₀) (ppcompose_left f₁₂)
            (ppcompose_left f₀₁) (ppcompose_left f₂₁) :=
  !ppcompose_left_pcompose⁻¹* ⬝* ppcompose_left_phomotopy p ⬝* !ppcompose_left_pcompose

  definition trans_phomotopy_hconcat {f₀₁' f₀₁''}
    (q₂ : f₀₁'' ~* f₀₁') (q₁ : f₀₁' ~* f₀₁) (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) :
    (q₂ ⬝* q₁) ⬝ph* p = q₂ ⬝ph* q₁ ⬝ph* p :=
  idp ◾** (ap (pwhisker_left f₁₂) !trans_symm ⬝ !pwhisker_left_trans) ⬝ !trans_assoc⁻¹

  definition symm_phomotopy_hconcat {f₀₁'} (q : f₀₁ ~* f₀₁')
    (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) : q⁻¹* ⬝ph* p = p ⬝* pwhisker_left f₁₂ q :=
  idp ◾** ap (pwhisker_left f₁₂) !symm_symm

  definition refl_phomotopy_hconcat (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) : phomotopy.rfl ⬝ph* p = p :=
  idp ◾** (ap (pwhisker_left _) !refl_symm ⬝ !pwhisker_left_refl) ⬝ !trans_refl

  local attribute phomotopy.rfl [reducible]
  theorem pwhisker_left_phomotopy_hconcat {f₀₁'} (r : f₀₁' ~* f₀₁)
    (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) (q : psquare f₁₂ f₁₄ f₀₃ f₂₃) :
    pwhisker_left f₀₃ r ⬝ph* (p ⬝v* q) = (r ⬝ph* p) ⬝v* q :=
  by induction r using phomotopy_rec_on_idp; rewrite [pwhisker_left_refl, +refl_phomotopy_hconcat]

  theorem pvcompose_pwhisker_left {f₀₁'} (r : f₀₁ ~* f₀₁')
    (p : psquare f₁₀ f₁₂ f₀₁ f₂₁) (q : psquare f₁₂ f₁₄ f₀₃ f₂₃) :
    (p ⬝v* q) ⬝* (pwhisker_left f₁₄ (pwhisker_left f₀₃ r)) = (p ⬝* pwhisker_left f₁₂ r) ⬝v* q :=
  by induction r using phomotopy_rec_on_idp; rewrite [+pwhisker_left_refl, + trans_refl]

  definition phconcat2 {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁} {q q' : psquare f₃₀ f₃₂ f₂₁ f₄₁}
    (r : p = p') (s : q = q') : p ⬝h* q = p' ⬝h* q' :=
  ap011 phconcat r s

  definition pvconcat2 {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁} {q q' : psquare f₁₂ f₁₄ f₀₃ f₂₃}
    (r : p = p') (s : q = q') : p ⬝v* q = p' ⬝v* q' :=
  ap011 pvconcat r s

  definition phinverse2 {f₁₀ : A₀₀ ≃* A₂₀} {f₁₂ : A₀₂ ≃* A₂₂} {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁}
    (r : p = p') : p⁻¹ʰ* = p'⁻¹ʰ* :=
  ap phinverse r

  definition pvinverse2 {f₀₁ : A₀₀ ≃* A₀₂} {f₂₁ : A₂₀ ≃* A₂₂} {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁}
    (r : p = p') : p⁻¹ᵛ* = p'⁻¹ᵛ* :=
  ap pvinverse r

  definition phomotopy_hconcat2 {q q' : f₀₁' ~* f₀₁} {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁}
    (r : q = q') (s : p = p') : q ⬝ph* p = q' ⬝ph* p' :=
  ap011 phomotopy_hconcat r s

  definition hconcat_phomotopy2 {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁} {q q' : f₂₁' ~* f₂₁}
    (r : p = p') (s : q = q') : p ⬝hp* q = p' ⬝hp* q' :=
  ap011 hconcat_phomotopy r s

  definition phomotopy_vconcat2 {q q' : f₁₀' ~* f₁₀} {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁}
    (r : q = q') (s : p = p') : q ⬝pv* p = q' ⬝pv* p' :=
  ap011 phomotopy_vconcat r s

  definition vconcat_phomotopy2 {p p' : psquare f₁₀ f₁₂ f₀₁ f₂₁} {q q' : f₁₂' ~* f₁₂}
    (r : p = p') (s : q = q') : p ⬝vp* q = p' ⬝vp* q' :=
  ap011 vconcat_phomotopy r s

  -- for consistency, should there be a second star here?
  infix ` ◾h* `:79 := phconcat2
  infix ` ◾v* `:79 := pvconcat2
  infixl ` ◾hp* `:79 := hconcat_phomotopy2
  infixr ` ◾ph* `:79 := phomotopy_hconcat2
  infixl ` ◾vp* `:79 := vconcat_phomotopy2
  infixr ` ◾pv* `:79 := phomotopy_vconcat2
  postfix `⁻²ʰ*`:(max+1) := phinverse2
  postfix `⁻²ᵛ*`:(max+1) := pvinverse2

  end psquare

    /- a more explicit proof of ppcompose_left_phomotopy, which might be useful if we need to prove properties about it
    -/
    -- fapply phomotopy_mk_ppmap,
    -- { intro f, exact pwhisker_right f p },
    -- { refine ap (λx, _ ⬝* x) !phomotopy_of_eq_of_phomotopy ⬝ _ ⬝ !phomotopy_of_eq_of_phomotopy⁻¹,
    --   exact pcompose_pconst_phomotopy p }

  definition ppcompose_left_phomotopy_refl {A B C : Type*} (g : B →* C) :
    ppcompose_left_phomotopy (phomotopy.refl g) = phomotopy.refl (@ppcompose_left A _ _ g) :=
  !phomotopy_rec_on_idp_refl

  -- definition pmap_eq_equiv {X Y : Type*} (f g : X →* Y) : (f = g) ≃ (f ~* g) :=
  -- begin
  --   refine eq_equiv_fn_eq_of_equiv (@pmap.sigma_char X Y) f g ⬝e _,
  --   refine !sigma_eq_equiv ⬝e _,
  --   refine _ ⬝e (phomotopy.sigma_char f g)⁻¹ᵉ,
  --   fapply sigma_equiv_sigma,
  --   { esimp, apply eq_equiv_homotopy },
  --   { induction g with g gp, induction Y with Y y0, esimp, intro p, induction p, esimp at *,
  --     refine !pathover_idp ⬝e _, refine _ ⬝e !eq_equiv_eq_symm,
  --     apply equiv_eq_closed_right, exact !idp_con⁻¹ }
  -- end

  definition pmap_eq_idp {X Y : Type*} (f : X →* Y) :
    pmap_eq (λx, idpath (f x)) !idp_con⁻¹ = idpath f :=
  ap (λx, eq_of_phomotopy (phomotopy.mk _ x)) !inv_inv ⬝ eq_of_phomotopy_refl f

  definition pfunext [constructor] (X Y : Type*) : ppmap X (Ω Y) ≃* Ω (ppmap X Y) :=
  begin
    fapply pequiv_of_equiv,
    { fapply equiv.MK: esimp,
      { intro f, fapply pmap_eq,
        { intro x, exact f x },
        { exact (respect_pt f)⁻¹ }},
      { intro p, fapply pmap.mk,
        { intro x, exact ap010 pmap.to_fun p x },
        { note z := apd respect_pt p,
          note z2 := square_of_pathover z,
          refine eq_of_hdeg_square z2 ⬝ !ap_constant }},
      { intro p, exact sorry },
      { intro p, exact sorry }},
    { apply pmap_eq_idp}
  end

  /-
    Do we want to use a structure of homotopies between pointed homotopies? Or are equalities fine?
    If we set up things more generally, we could define this as
    "pointed homotopies between the dependent pointed maps p and q"
  -/
  structure phomotopy2 {A B : Type*} {f g : A →* B} (p q : f ~* g) : Type :=
    (homotopy_eq : p ~ q)
    (homotopy_pt_eq : whisker_right (respect_pt g) (homotopy_eq pt) ⬝ to_homotopy_pt q = to_homotopy_pt p)

  /- this sets it up more generally, for illustrative purposes -/
  structure ppi' (A : Type*) (P : A → Type) (p : P pt) :=
    (to_fun : Π a : A, P a)
    (resp_pt : to_fun (Point A) = p)
  attribute ppi'.to_fun [coercion]
  definition ppi_homotopy' {A : Type*} {P : A → Type} {x : P pt} (f g : ppi' A P x) : Type :=
  ppi' A (λa, f a = g a) (ppi'.resp_pt f ⬝ (ppi'.resp_pt g)⁻¹)
  definition ppi_homotopy2' {A : Type*} {P : A → Type} {x : P pt} {f g : ppi' A P x} (p q : ppi_homotopy' f g) : Type :=
  ppi_homotopy' p q

  infix ` ~*2 `:50 := phomotopy2

  variables {A B : Type*} {f g : A →* B} (p q : f ~* g)

  -- definition phomotopy_eq_equiv_phomotopy2 : p = q ≃ p ~*2 q :=
  -- sorry

end pointed