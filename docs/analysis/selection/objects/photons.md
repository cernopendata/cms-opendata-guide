# Photons

!!! Warning
    This page is under construction

## Introduction

## Photon 4-vector information

## Photon identification

PHOTONS

``` cpp
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
      double corrPFNHIso = max(it->neutralHadronIso() - rhoIso *NH_AEff, 0.);
double corrPFPhIso = max(it->photonIso() - rhoIso* Ph_AEff, 0.);
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

```
