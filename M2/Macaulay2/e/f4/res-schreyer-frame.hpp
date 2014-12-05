// Copyright 2014 Michael E. Stillman

#ifndef _res_schreyer_frame_hpp_
#define _res_schreyer_frame_hpp_

#include "moninfo.hpp"
#include "memblock.hpp"
#include "varpower-monomial.hpp"
#include <vector>

class SchreyerFrame
{
public:
  struct FrameElement
  {
    packed_monomial mMonom; // has component, degree too
    long mDegree;
    long mBegin; // points into next level's elements
    long mEnd;
    FrameElement() {}
    FrameElement(packed_monomial monom) : mMonom(monom), mDegree(0), mBegin(0), mEnd(0) {}
    FrameElement(packed_monomial monom, long deg) : mMonom(monom), mDegree(deg), mBegin(0), mEnd(0) {}
  };

  // Construct an empty frame
  SchreyerFrame(const MonomialInfo& MI, int max_level);
  
  // Destruct the frame
  ~SchreyerFrame();

  // This is where we place the monomials in the frame
  // This requires some care from people calling this function
  MemoryBlock<monomial_word>& monomialBlock() { return mMonomialSpace; }

  // Debugging //
  void show() const;

  // Return number of bytes in use.
  long memoryUsage() const;

  // Display memory usage for this computation
  void showMemoryUsage() const;

  // Actual useful functions //
  void endLevel(); // done with the frame for the current level: set's the begin/end's 
                   // for each element at previous level

  long computeNextLevel(); // returns true if new elements are constructed

  // insert monomial into level 0
  // monom should have been allocated using monomialBlock().
  // The frame now owns this pointer
  long insert(packed_monomial monom, long degree);

  // insert monomial into level 1
  // monom should have been allocated using monomialBlock().
  // The frame now owns this pointer
  long insert(packed_monomial monom); // computes the degree

  packed_monomial monomial(int lev, long component) { return level(lev)[component].mMonom; }

  void getBounds(int& loDegree, int& hiDegree, int& length) const;
  M2_arrayint getBettiFrame() const;
  ///////////////////////
  // Display functions //
  ///////////////////////
  // Betti (for non-minimal Betti)
private:
  struct PreElement
  {
    varpower_monomial vp;
    int degree;
  };

  class PreElementSorter
  {
  public:
    typedef PreElement* value;
  private:
    static long ncmps;
  public:
    int compare(value a, value b)
    {
      ncmps ++;
      if (a->degree > b->degree) return GT;
      if (a->degree < b->degree) return LT;
      return varpower_monomials::compare(a->vp, b->vp);
    }
    
    bool operator()(value a, value b)
    {
      ncmps ++;
      if (a->degree > b->degree) return false;
      if (a->degree < b->degree) return true;
      return varpower_monomials::compare(a->vp, b->vp) == LT;
    }
    
    PreElementSorter() {}
    
    void reset_ncomparisons() { ncmps = 0; }
    long ncomparisons() const { return ncmps; }
    
    ~PreElementSorter() {}
  };
  
  struct Level
  {
    std::vector<FrameElement> mElements;
  };
  struct Frame
  {
    std::vector<Level> mLevels;
  };

  int currentLevel() const { return mCurrentLevel; }
  long degree(int lev, long component) const { return level(lev)[component].mDegree; }
  long degree(int lev, packed_monomial m) const { return m[2] + degree(lev-1, m[1]); }
  std::vector<FrameElement>& level(int lev) { return mFrame.mLevels[lev].mElements; }
  const std::vector<FrameElement>& level(int lev) const { return mFrame.mLevels[lev].mElements; }

  PreElement* createQuotientElement(packed_monomial m1, packed_monomial m);
  long computeIdealQuotient(int lev, long begin, long elem);
  long insertElements(int lev, long elem);


  // Private Data
  const MonomialInfo& mMonoid;
  Frame mFrame;
  MemoryBlock<monomial_word> mMonomialSpace; // We keep all of the monomials here, in order

  // These are used during frame construction
  int mCurrentLevel;
  MemoryBlock<PreElement> mPreElements;
  MemoryBlock<varpower_word> mVarpowers;
  int mMaxVPSize;
};

#endif

// Local Variables:
// compile-command: "make -C $M2BUILDDIR/Macaulay2/e "
// indent-tabs-mode: nil
// End:

