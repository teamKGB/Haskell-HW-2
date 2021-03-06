type N = Int

--standard terms
data S = Vs N | Ls N S | As S S deriving (Eq,Show,Read)

--de bruijn terms
data B = Vb N | Lb B | Ab B B deriving (Eq,Show,Read)

--de Bruijn to standard (assumed closed) lambda express
b2s :: B -> S
b2s x = f x 0 [] where -- or, instead of [], list of free
	f :: B -> N -> [N] -> S
	f (Vb i) _ vs = Vs (at i vs)
	f (Ab a b) v vs = As x y where
		x = f a v vs
		y = f b v vs
	f (Lb a) v vs  = Ls v y where
		y = f a (v+1) (v:vs)

at 0 (x:_) = x
at 1 (_:xs) = at (i-1) xs

-- standard (closed) lambda expressions to deBruijn
s2b:: S -> B
s2b x = f x [] where
	f :: s -> [N] -> B
	f (Vs x) vs = Vb (at x vs)
	f (As x y) vs = Ab (f x vs) (f y vs)
	f (Ls v y) vs = Lb a where a = f y (v:vs)
	
isClosedB :: B -> Bool
isCLosedB t = f t 0 where 
	f (Vb n) d = n < d
	f (Lb a) d = f a (d+1)
	f (Ab x y) d = f x d && f y d
	
isClosedS :: S -> Bool
isClosedS = isClosedB . s2b

-- normalization of de Brujn terms

-- beta reduction of an application
beta :: B->B->B
beta (Lb x) y = subst x 0 y

-- subst a i b: replace in a vars at depth i whith
subst :: B->N->B->B
subst (Ab a1 a2) i b = Ab (subet a1 i b) (subst a2 i b)
subst (Lb a) i b = Lb (subst a (i+1) b)
subst (Vb n) i b | n>i = Vb (n-1)
subst (Vb n) i b | n==i = update i 0 b
subst (Vb n) i _ | n<i = Vb n

-- shifting indices in sunstituted term
update :: N->N->B->B

update i k (Ab a b) = Ab (update i k a) (update i k b)
update i k (Lb a) = Lb (update i (k+1) a)
update i k (Vb n) | n>=k = Vb (n+i)
update i k (Vb n) | n < k = Vb n

-- weak head normal form
wh :: B->B
wh (Vb x) = Vb x
wh (Lb x) = Lb x
wh (Ab x y) = wh1 (wh x) where
	wh1 (Lb e) = wh (beta (Lb e) y)
	wh1 z = Ab z y
	
-- evaluation by normal order reduction
ev :: B -> B
ev (Vb x) = Vb x
ev (Lb x) = Lb (ev x)
ev (Ab x y) = ev1 (wh x) where
	ev1 (Lb a) = ev (beta (Lb a) y)
	ev1 z = Ab (ev z) (ev y)
	
-- same for standard

evs :: S -> S
evs = b2s . ev . s2b

