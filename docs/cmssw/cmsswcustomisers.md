# NanoAOD Customisers

!!! Warning
    This guide is under construction!

NanoAOD format consists of flat Ntuples which are readable by bare ROOT and is not a CMSSW EDM file. NanoAOD can be centraly produced or privately produced for specific analyses. NanoAOD customisation modules within CMSSW are designed to modify the nanoAOD format for specific physics analyses. NanoAOD customisers are compatible from **CMSSW_10_2_X** and subsequent releases.

These modules typically:

- Modify the variables or object collections.
- Recompute or correct existing quantities.
- Modify the sequence of NanoAOD production workflow.

NanoAOD customisation modules are crucial because the centrally produced NanoAOD format, while efficient can sometimes be insufficient for certain physics analyses. These modules allows one to modify physics object collections as per required needs.

Some of the customisers are listed below:

- **`nano_cff.py`**: Central configuration file that defines sequences and modules for NanoAOD production workflow (object reconstruction, selection and table creation). Allows modifications of variables and object collections.
- **`custom_jme_cff.py`**: Customisation module that modifies and extends the jet and MET collections in NanoAOD. It can add new variables, recalculate existing quantities and introduce alternate algorithms.

There are other customisation modules that help the central configuration `nano_cff.py` by providing additional configurations and sequences for different physics objects. Learn more about them [here](https://github.com/cms-sw/cmssw/tree/CMSSW_10_6_X/PhysicsTools/NanoAOD/python).

There are some example customisers provided to learn more about these customisers in this [GitHub repository](https://github.com/xondikoi03/nanoAODCustomisation).
<!-- MAYBE AN EXERCISE NEEDS TO BE HERE-->