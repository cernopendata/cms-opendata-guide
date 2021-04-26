#  Objects

!!! Warning
    This page is under construction

This twiki contains information on electron selection intended to be used with 2010 data. The selection is based on cuts on a small number of variables. Different thresholds are used for electrons found in the ECAL barrel and the ECAL endcap. Electron selection variables may be categorized in 3 groups:
e-ID variables (shower shape, track cluster matching etc)
isolation variables
conversion rejection variables
The sets of cuts given here are obtained by tuning all cuts together, but the sets of cuts on each of the 3 groups of variables may be used alone quite effectively. The fake rate, and fake sources, vary with ET, and for any set of cuts, rejection power and efficiency vary with ET. However, sets of cuts optimized for ET>25 GeV are near optimal for the interval 100>ET>20 GeV, and can usefully be employed down to 15 GeV. Ultimately the most performant selection should be obtained using multi-variate techniques, likelihood fits etc. Prior to that cut-based selections can provide a useful tool to understand the data and make comparison with MC. The advantages of "Simple Cuts" are:

Cut inversion (used in many data driven signal extraction and background subtraction methodologies) is simple
Smallest statistics are needed for full understanding and efficiency measurement
It is simple to cleanly separate the e-ID, isolation and conversion rejection pieces
The selection has been tuned in order to get a set of cuts with maximum background rejection for a given efficiency.

'''
ELECTRONS
 // Electrons
  Handle<GsfElectronCollection> electrons;
  iEvent.getByLabel(InputTag("gsfElectrons"), electrons);
  edm::Handle<reco::ConversionCollection> hConversions;
  iEvent.getByLabel("allConversions", hConversions);
  edm::Handle<reco::BeamSpot> bsHandle;
  iEvent.getByLabel("offlineBeamSpot", bsHandle);
  const reco::BeamSpot &beamspot = *bsHandle.product();
  
  value_el_n = 0;
  const float el_min_pt = 5;
  std::vector<GsfElectron> selectedElectrons;
  for (auto it = electrons->begin(); it != electrons->end(); it++) {
    if (it->pt() > el_min_pt) {
      selectedElectrons.emplace_back(*it);


      value_el_cutbasedid[value_el_n] = it->passingCutBasedPreselection();
      value_el_pfid[value_el_n] = it->passingPflowPreselection();
      //added for cut based id
      value_el_sigIetaIeta[value_el_n] = it->sigmaIetaIeta();
      value_el_hOverEm[value_el_n] = it->hadronicOverEm();
      value_el_fbrem[value_el_n] = it->fbrem();
      value_el_eOverP[value_el_n] = it->eSuperClusterOverP();
      value_el_dEtaIn[value_el_n] = it->deltaEtaSuperClusterTrackAtVtx();
      value_el_dPhiIn[value_el_n] = it->deltaPhiSuperClusterTrackAtVtx();
      value_el_ecalE[value_el_n] = it->ecalEnergy();
      //value_el_pIn[value_el_n] = it->trackMomentumAtVtx().p(); //Does not compile: 'math::XYZVectorF' has no member named 'p'
      value_el_pIn[value_el_n] = ( it->ecalEnergy() / it->eSuperClusterOverP() ); //same as above line according to twiki
      value_el_dr03TkSumPt[value_el_n] = it->dr03TkSumPt();
      value_el_dr03EcalRecHitSumEt[value_el_n] = it->dr03EcalRecHitSumEt();
      value_el_dr03HcalTowerSumEt[value_el_n] = it->dr03HcalTowerSumEt();
      value_el_expectedHits[value_el_n] = it->gsfTrack()->trackerExpectedHitsInner().numberOfHits();
      int missing_hits = it->gsfTrack()->trackerExpectedHitsInner().numberOfHits()-it->gsfTrack()->hitPattern().numberOfHits();
      bool passelectronveto = !ConversionTools::hasMatchedConversion(*it, hConversions, beamspot.position());
      if (it->passingPflowPreselection()) {
        auto iso03 = it->pfIsolationVariables();
        value_el_pfreliso03all[value_el_n] =
            (iso03.chargedHadronIso + iso03.neutralHadronIso + iso03.photonIso)/it->pt();
      } else {
        value_el_pfreliso03all[value_el_n] = -999;
      }
      float pfIso = value_el_pfreliso03all[value_el_n];
      auto trk = it->gsfTrack();

            value_el_jetidx[value_el_n] = -1;
      value_el_genpartidx[value_el_n] = -1;
      value_el_isLoose[value_el_n] = false;
      value_el_isMedium[value_el_n] = false;
      value_el_isTight[value_el_n] = false;
      if ( abs(it->eta()) <= 1.479 ) {   
      if ( abs(it->deltaEtaSuperClusterTrackAtVtx())<.007 && abs(it->deltaPhiSuperClusterTrackAtVtx())<.15 && 
           it->sigmaIetaIeta()<.01 && it->hadronicOverEm()<.12 && 
	        abs(trk->dxy(pv))<.02 && abs(trk->dz(pv))<.2 && 
		     missing_hits<=1 && pfIso<.15 && passelectronveto==true &&
		          abs(1/it->ecalEnergy()-1/(it->ecalEnergy()/it->eSuperClusterOverP()))<.05 ){
			    
          value_el_isLoose[value_el_n] = true;
	    
	      if ( abs(it->deltaEtaSuperClusterTrackAtVtx())<.004 && abs(it->deltaPhiSuperClusterTrackAtVtx())<.06 && abs(trk->dz(pv))<.1 ){
	          value_el_isMedium[value_el_n] = true;
		      
		          if (abs(it->deltaPhiSuperClusterTrackAtVtx())<.03 && missing_hits<=0 && pfIso<.10 ){
			        value_el_isTight[value_el_n] = true;
				    }
				      }
				      }
      }
      else if ( abs(it->eta()) > 1.479 && abs(it->eta()) < 2.5 ) {
        if ( abs(it->deltaEtaSuperClusterTrackAtVtx())<.009 && abs(it->deltaPhiSuperClusterTrackAtVtx())<.1 && 
	     it->sigmaIetaIeta()<.03 && it->hadronicOverEm()<.1 && 
	          abs(trk->dxy(pv))<.02 && abs(trk->dz(pv))<.2 && 
		       missing_hits<=1 && pfIso<.15 && passelectronveto==true &&
             abs(1/it->ecalEnergy()-1/(it->ecalEnergy()/it->eSuperClusterOverP()))<.05) {
	       
          value_el_isLoose[value_el_n] = true;
	    
	      if ( abs(it->deltaEtaSuperClusterTrackAtVtx())<.007 && abs(it->deltaPhiSuperClusterTrackAtVtx())<.03 && abs(trk->dz(pv))<.1 ){
	          value_el_isMedium[value_el_n] = true;
		      
		          if ( abs(it->deltaEtaSuperClusterTrackAtVtx())<.005 && abs(it->deltaPhiSuperClusterTrackAtVtx())<.02 && missing_hits<=0 && pfIso<.10 ){
			        value_el_isTight[value_el_n] = true;
				    }
				      }
        }
      }
      value_el_n++;
    }
  }


PHOTONS
  // Photons
  Handle<PhotonCollection> photons;
  iEvent.getByLabel(InputTag("photons"), photons);
  Handle<double> rhoHandle;
  iEvent.getByLabel(InputTag("fixedGridRhoAll"), rhoHandle);
  double rhoIso = std::max(*(rhoHandle.product()), 0.0);

  value_ph_n = 0;
  const float ph_min_pt = 5;
  std::vector<Photon> selectedPhotons;
  for (auto it = photons->begin(); it != photons->end(); it++) {
    if (it->pt() > ph_min_pt) {
      bool passelectronveto = !ConversionTools::hasMatchedPromptElectron(it->superCluster(), electrons, hConversions, beamspot.position());
      double scEta = (it)->superCluster()->eta();
      double CH_AEff, NH_AEff, Ph_AEff;
      if(fabs(scEta) >2.4) {
      CH_AEff = 0.012;
      NH_AEff = 0.072;
      Ph_AEff = 0.266;
      }
      else if(fabs(scEta) >2.3) {
        CH_AEff = 0.020;
	NH_AEff = 0.039;
        Ph_AEff = 0.260;
      } 
      else if(fabs(scEta) >2.2) {
        CH_AEff = 0.016;
	NH_AEff = 0.024;
        Ph_AEff = 0.262;
      } 
      else if(fabs(scEta) >2.0) {
        CH_AEff = 0.012;
	NH_AEff = 0.015;
        Ph_AEff = 0.216;
      } 
      else if(fabs(scEta) >1.479) {
        CH_AEff = 0.014;
	NH_AEff = 0.039;
        Ph_AEff = 0.112;
      } 
      else if(fabs(scEta) >0.1) {
        CH_AEff = 0.010;
	NH_AEff = 0.057;
        Ph_AEff = 0.130;
      } 
      else {
        CH_AEff = 0.012;
	NH_AEff = 0.030;
        Ph_AEff = 0.148;
      } 
            selectedPhotons.emplace_back(*it);
      value_ph_pt[value_ph_n] = it->pt();
      value_ph_eta[value_ph_n] = it->eta();
      value_ph_phi[value_ph_n] = it->phi();
      value_ph_charge[value_ph_n] = it->charge();
      value_ph_mass[value_ph_n] = it->mass();
      value_ph_pfreliso03all[value_ph_n] = it->ecalRecHitSumEtConeDR03() / it->pt();
      value_ph_jetidx[value_ph_n] = -1;
      value_ph_genpartidx[value_ph_n] = -1;
      //added for cut based id
      //value_ph_passelectronveto[max_ph];
      value_ph_hOverEm[value_ph_n] = it->hadTowOverEm();
      value_ph_sigIetaIeta[value_ph_n] = it->sigmaIetaIeta();
      value_ph_chargedHadronIso[value_ph_n] = it->chargedHadronIso();
      value_ph_neutralHadronIso[value_ph_n] = it->neutralHadronIso();
      value_ph_photonIso[value_ph_n] = it->photonIso();      
      double corrPFCHIso = max(it->chargedHadronIso() - rhoIso * CH_AEff, 0.);
      double corrPFNHIso = max(it->neutralHadronIso() - rhoIso * NH_AEff, 0.);
      double corrPFPhIso = max(it->photonIso() - rhoIso * Ph_AEff, 0.);
      value_ph_isTight[value_ph_n] = false;
      value_ph_isMedium[value_ph_n] = false;
      value_ph_isLoose[value_ph_n] = false;
      if ( it->eta() <= 1.479 ){
      if ( it->hadTowOverEm()<.05 && it->sigmaIetaIeta()<.012 && 
           corrPFCHIso<2.6 && corrPFNHIso<(3.5+.04*it->pt()) && 
	        corrPFPhIso<(1.3+.005*it->pt()) && passelectronveto==true) {
          value_ph_isLoose[value_ph_n] = true;

	    if ( it->sigmaIetaIeta()<.011 && corrPFCHIso<1.5 && corrPFNHIso<(1.0+.04*it->pt()) && corrPFPhIso<(.7+.005*it->pt())){
	        value_ph_isMedium[value_ph_n] = true;

		    if ( corrPFCHIso<.7 && corrPFNHIso<(.4+.04*it->pt()) && corrPFPhIso<(.5+0.005*it->pt()) ){
		          value_ph_isTight[value_ph_n] = true;
			      }
			        }
				}
      }
      else if ( it->eta() > 1.479 && it->eta() < 2.5 ) {
      if ( it->hadTowOverEm()<.05 && it->sigmaIetaIeta()<.034 && corrPFCHIso<2.3 && corrPFNHIso<(2.9+.04*it->pt()) && passelectronveto==true ){
          value_ph_isLoose[value_ph_n] = true;
	    
	      if ( it->sigmaIetaIeta()<.033 && corrPFCHIso<1.2 && corrPFNHIso<(1.5+.04*it->pt()) && corrPFPhIso<(1.0+.005*it->pt())) {
	          value_ph_isMedium[value_ph_n] = true;

		      if ( it->sigmaIetaIeta()<0.031 && corrPFCHIso<0.5){
		            value_ph_isTight[value_ph_n] = true;
			        }
				  }
				  }
      }
      value_ph_n++;
    }
  }
'''