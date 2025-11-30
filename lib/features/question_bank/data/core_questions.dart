import 'question_model.dart';

const List<QuestionItem> coreQuestions = [
  QuestionItem(
    id: 'CORE-Q1',
    industry: 'Core Engineering',
    topic: 'Stress and Strain',
    question: '''What is the difference between Stress and Strain?
(Asked at: L&T Mechanical, Tata Motors)''',
    shortAnswer: '''Stress is the internal resistance developed within a material when an external force is applied, measured as force per unit area (N/m²). Strain is the deformation produced due to stress, expressed as a dimensionless ratio (change in length/original length). Stress causes strain, while strain indicates material deformation. In design, understanding their relationship helps prevent failure and select suitable materials.''',
    deepExplanation: '''Stress = Force/Area. It determines how much load a component can withstand before deforming. Strain tells how much the material changes under that stress. Hooke’s Law defines linear relation: Stress = E × Strain. The modulus of elasticity determines material stiffness. Ductile materials allow large strains; brittle ones fail early. These concepts are fundamental for machine design, FEA simulations, and structural engineering.

Example
A steel rod of 10 mm² cross section under 1000 N load → stress = 100 MPa.

Mistakes
Confusing strain units


Assuming all materials follow Hooke’s law


Tips
Remember: stress is cause; strain is effect.


Resources
V.B. Bhandari – Machine Design (Chapter 2)''',
  ),
  QuestionItem(
    id: 'CORE-Q2',
    industry: 'Core Engineering',
    topic: 'Bernoulli’s Theorem',
    question: '''Explain Bernoulli’s Theorem.
(Asked at: BHEL, Fluid Mechanics interviews)''',
    shortAnswer: '''Bernoulli’s theorem states that for an incompressible, non-viscous fluid in steady flow, the sum of pressure energy, kinetic energy, and potential energy per unit volume remains constant. It describes the energy conservation principle in fluid motion. Applications include aircraft wings, Venturi meters, and pipe flow analysis.''',
    deepExplanation: '''Bernoulli’s equation:
 P + ½ρv² + ρgh = constant
 It assumes no friction loss and steady streamline flow. Speed increases → pressure decreases. Engineers use this principle for measuring flow rates, designing turbines, pumps, and understanding cavitation. Deviations occur when viscosity, turbulence, or compressibility is significant.

Example
Venturi meter uses pressure drop to calculate flow rate.

Mistakes
Applying Bernoulli to viscous or turbulent flows directly


Tips
Always check assumptions before applying.


Resources
Cengel — Fluid Mechanics''',
  ),
  QuestionItem(
    id: 'CORE-Q3',
    industry: 'Core Engineering',
    topic: '2-Stroke vs 4-Stroke',
    question: '''What is the difference between 2-Stroke and 4-Stroke Engines?
(Asked at: Ashok Leyland, Tata Motors)''',
    shortAnswer: '''A 2-stroke engine completes its power cycle in one revolution with two strokes (power every stroke), while a 4-stroke completes in two revolutions with four strokes (power every two strokes). 2-strokes are lighter and more powerful for their size but less fuel-efficient and more polluting. 4-strokes are cleaner, quieter, and used widely in automobiles.''',
    deepExplanation: '''2-strokes combine intake and compression in one stroke; power and exhaust in another. 4-strokes separate intake, compression, power, exhaust. 4-strokes use valves; 2-strokes use ports. Due to better combustion control, 4-strokes give higher mileage and reduced emissions. 2-strokes are used in small engines, marine, and off-road.

Example
Bikes (4-stroke) vs older scooters/chainsaws (2-stroke).

Mistakes
Assuming 2-strokes are “faster” always


Tips
Always mention emissions — key interview point.


Resources
I.C Engine by V. Ganeshan''',
  ),
  QuestionItem(
    id: 'CORE-Q4',
    industry: 'Core Engineering',
    topic: 'Power Factor',
    question: '''What is Power Factor?
(Asked at: Tata Power, Siemens)''',
    shortAnswer: '''Power factor is the cosine of the phase angle between voltage and current in an AC circuit. It indicates how effectively electrical power is converted into useful work. A power factor of 1 means maximum efficiency. Low PF leads to higher losses and penalties.''',
    deepExplanation: '''PF = Real Power (kW) / Apparent Power (kVA).
 Loads like motors, transformers create inductive lagging PF. Low PF causes voltage drops, overheating, and inefficient grid usage. Capacitors or synchronous condensers correct PF. Industries must maintain PF close to unity to avoid fines.

Example
PF of 0.7 → requires 30% extra current.

Mistakes
Saying PF applies to DC systems (wrong)


Tips
Mention PF penalties — impresses interviewers.


Resources
Nagrath & Kothari — Power Systems''',
  ),
  QuestionItem(
    id: 'CORE-Q5',
    industry: 'Core Engineering',
    topic: 'Transformer Efficiency',
    question: '''Define Transformer Efficiency.
(Asked at: ABB, BHEL)''',
    shortAnswer: '''Transformer efficiency is the ratio of output power to input power, typically ranging between 95–99%. Since transformers have no moving parts, their losses include iron losses (core losses) and copper losses (I²R). Efficiency improves at rated load.''',
    deepExplanation: '''η = Output / Input
 Iron losses are constant (hysteresis + eddy current). Copper losses vary with load. Maximum efficiency occurs when iron loss = copper loss. High-efficiency transformers reduce heating and energy waste, especially in transmission systems.

Example
98% efficient transformer → 2% energy loss.

Mistakes
Ignoring stray losses


Tips
Always mention condition for maximum efficiency.


Resources
J.B. Gupta — Electrical Machines''',
  ),
  QuestionItem(
    id: 'CORE-Q6',
    industry: 'Core Engineering',
    topic: 'HVAC vs HVACR',
    question: '''What is the difference between HVAC and HVACR?
(Asked at: L&T Construction, Real Estate MEP roles)''',
    shortAnswer: '''HVAC stands for Heating, Ventilation, and Air Conditioning. HVACR adds Refrigeration to the system. HVAC handles indoor comfort; HVACR includes cold storage, refrigeration cycles, and industrial cooling applications.''',
    deepExplanation: '''HVAC systems maintain temperature, humidity, and air quality. HVACR includes vapor compression cycles, condenser units, evaporators, and refrigerants. Engineers handle load calculations, duct design, psychrometrics, and compressor types. HVACR is crucial for supermarkets, pharma, cold chains.

Example
Residential AC = HVAC;
 Cold storage warehouse = HVACR.

Mistakes
Saying HVACR is “just bigger HVAC”


Tips
Mention psychrometric chart basics.


Resources
ASHRAE Handbook''',
  ),
  QuestionItem(
    id: 'CORE-Q7',
    industry: 'Core Engineering',
    topic: 'Slip in Induction Motor',
    question: '''What is Slip in an Induction Motor?
(Asked at: Siemens, Tata Steel)''',
    shortAnswer: '''Slip is the difference between synchronous speed and rotor speed, expressed as a percentage of synchronous speed. Slip allows torque production in induction motors. Without slip, no relative motion → no current → no torque.''',
    deepExplanation: '''Slip (s) = (Ns – Nr) / Ns.
 Ns = 120f/P
 As load increases → rotor slows → slip increases → torque increases. Motors operate typically between 2–6% slip. Excessive slip indicates overload or faults.

Example
Ns = 1500 RPM, Rotor = 1450 → slip = 3.33%

Mistakes
Saying zero slip is ideal (it gives zero torque!)


Tips
Always mention torque-slip curve.


Resources
Fitzgerald — Electric Machinery''',
  ),
  QuestionItem(
    id: 'CORE-Q8',
    industry: 'Core Engineering',
    topic: 'SFD/BMD',
    question: '''What is a Shear Force and Bending Moment Diagram (SFD/BMD)?
(Asked at: Civil site engineer roles)''',
    shortAnswer: '''SFD shows internal shear force variation across a beam, and BMD shows bending moment variation. They help identify maximum shear/moment locations, which dictate beam design, reinforcement, and safety. These diagrams prevent structural failures by predicting load effects.''',
    deepExplanation: '''Loads (point, UDL, moments) create internal reactions. Engineers compute reactions, plot shear values, integrate shear → bending moment. BMD peak indicates where reinforcement must be strongest. SFD/BMD are essential in RCC design, bridge engineering, and structural audits.

Example
Simply supported beam with UDL → parabolic BMD.

Mistakes
Mixing sign conventions


Tips
Draw SFD first → then BMD.


Resources
R.C. Hibbeler — Structural Analysis''',
  ),
  QuestionItem(
    id: 'CORE-Q9',
    industry: 'Core Engineering',
    topic: 'Concrete Curing',
    question: '''What is Concrete Curing and why is it important?
(Asked at: UltraTech, L&T Civil)''',
    shortAnswer: '''Curing maintains adequate moisture, temperature, and time to allow concrete to gain strength. Proper curing prevents cracks, improves durability, and achieves design strength. Curing is critical during the first 7–14 days.''',
    deepExplanation: '''Concrete gains strength from hydration. Without proper moisture, hydration slows → low strength, cracks, dusting. Methods include ponding, wet coverings, curing compounds, and steam curing. Hot climates require more aggressive curing.

Example
Curing slabs with wet hessian cloth for 7 days.

Mistakes
Curing only edges


Stopping too early


Tips
Follow IS 456 guidelines.


Resources
IS 456: Code of Practice''',
  ),
  QuestionItem(
    id: 'CORE-Q10',
    industry: 'Core Engineering',
    topic: 'AC vs DC Motors',
    question: '''What is the difference between AC and DC Motors?
(Asked at: Siemens, Thermax)''',
    shortAnswer: '''AC motors run on alternating current, use induction or synchronous principles, and are widely used in industrial applications. DC motors run on direct current and offer excellent speed control and torque at low RPM. AC motors are simpler and cheaper; DC motors require commutators.''',
    deepExplanation: '''AC motors: induction motors → no brushes, robust, low maintenance. DC motors: high starting torque, variable speed control. With modern VFDs, AC motors now compete in variable-speed applications.

Example
Electric trains use AC traction motors; robotics often use DC motors.

Mistakes
Saying AC motors cannot control speed (VFDs solve this)


Tips
Mention modern drives (VFD, PWM).


Resources
Electrical Machines — Nagrath & Kothari''',
  ),
  QuestionItem(
    id: 'CORE-Q11',
    industry: 'Core Engineering',
    topic: 'First Law of Thermodynamics',
    question: '''Explain the First Law of Thermodynamics.
(Asked at: NTPC, BHEL, ISRO basic interviews)''',
    shortAnswer: '''The First Law states that energy cannot be created or destroyed—only transformed. For a closed system, heat added equals internal energy increase plus work done by the system. It connects heat transfer, work, and internal energy, forming the foundation of thermodynamics and all engine cycles.''',
    deepExplanation: '''Mathematically: Q – W = ΔU.
 This law applies to steam turbines, boilers, compressors, refrigerators, and gasoline engines. In IC engines, fuel chemical energy → heat → work. In compressors, work input → increased internal energy. Understanding it helps calculate efficiencies, work outputs, and cycle performance via P–V/T–S diagrams.

Example
Heat supplied to steam in a boiler increases internal energy & produces expansion work in a turbine.

Mistakes
Confusing ΔU and ΔH


Assuming Q = W in all processes


Tips
Always specify system type (closed/open).


Resources
Cengel Thermodynamics – Chapter 2''',
  ),
  QuestionItem(
    id: 'CORE-Q12',
    industry: 'Core Engineering',
    topic: 'Cavitation',
    question: '''What is Cavitation in Pumps?
(Asked at: L&T, Kirloskar, ONGC)''',
    shortAnswer: '''Cavitation occurs when pressure in a pump drops below the fluid’s vapor pressure, forming vapor bubbles that collapse violently. This causes noise, vibration, efficiency loss, and severe impeller damage. Maintaining NPSH above minimum prevents cavitation.''',
    deepExplanation: '''When liquid pressure falls below vapor pressure—often at pump suction—bubbles form. When these travel to high-pressure zones, they implode, causing micro-jet impacts on metal. Cavitation erodes impellers, reduces flow, and overheats pumps. NPSH (Net Positive Suction Head) must be managed via proper suction line design, avoiding high fluid temperatures or long suction pipes.

Example
River-water pump cavitating due to clogged suction strainer.

Mistakes
Ignoring NPSH


Using undersized suction pipes


Tips
Keep suction line short, smooth


Avoid high inlet temperature


Resources
Hydraulic Institute Standards''',
  ),
  QuestionItem(
    id: 'CORE-Q13',
    industry: 'Core Engineering',
    topic: 'Transformer Principle',
    question: '''Explain the Working Principle of a Transformer.
(Asked at: Schneider Electric, ABB)''',
    shortAnswer: '''A transformer works on mutual induction. When AC flows in the primary coil, it creates a changing magnetic field, inducing voltage in the secondary coil. It steps voltage up or down depending on turns ratio, with no mechanical motion.''',
    deepExplanation: '''EMF induced ∝ rate of flux change (Faraday’s Law).
 Step-up → Ns > Np
 Step-down → Np > Ns
 Core materials (CRGO steel) reduce hysteresis loss. Transformers are used for power distribution, isolation, welding, and electronics. Efficiency is high because there are no moving parts.

Example
230V to 12V transformer in chargers.

Mistakes
Saying transformers work on DC (false)


Tips
Mention iron & copper losses.


Resources
J.B. Gupta – Electrical Machines''',
  ),
  QuestionItem(
    id: 'CORE-Q14',
    industry: 'Core Engineering',
    topic: 'Stress–Strain Curve',
    question: '''What is a Stress–Strain Curve?
(Asked at: Tata Steel, L&T Construction)''',
    shortAnswer: '''A stress–strain curve shows how a material behaves under tension—from elastic region to plastic region until fracture. It reveals properties like Young’s modulus, yield strength, ultimate strength, and ductility. Engineers use it to select safe materials for structures and machines.''',
    deepExplanation: '''Elastic region: material returns to original shape.
 Yield point: permanent deformation begins.
 Ultimate strength: max stress material can take.
 Necking → fracture.
 This curve guides design of beams, columns, shafts, pressure vessels, and automotive parts.

Example
Mild steel curve: distinct yield point → ductile behavior.

Mistakes
Thinking all materials show yield point


Tips
Mention Hooke’s limit.


Resources
Material Science by William Callister''',
  ),
  QuestionItem(
    id: 'CORE-Q15',
    industry: 'Core Engineering',
    topic: 'Earthing',
    question: '''What is Earthing and Why is it Important?
(Asked at: PowerGrid, Tata Power)''',
    shortAnswer: '''Earthing provides a safe path for fault current to flow into the ground, preventing electric shock and protecting equipment. It keeps exposed metal parts at zero potential and ensures protective devices trip during faults.''',
    deepExplanation: '''Systems include plate earthing, rod earthing, and earthing grids. Fault currents flow via low-resistance path → MCB/RCCB trips. Earthing prevents hazards, lightning damage, and overvoltage conditions. IS/IEC standards specify resistivity and testing methods.

Example
Metal body of washing machine connected to earth.

Mistakes
Using dry soil (high resistance)


Tips
Maintain earth pit moisture.


Resources
IS 3043: Code of Practice for Earthing''',
  ),
  QuestionItem(
    id: 'CORE-Q16',
    industry: 'Core Engineering',
    topic: 'Creep',
    question: '''What is Creep in Materials?
(Asked at: Thermal plants, Metallurgy roles)''',
    shortAnswer: '''Creep is the time-dependent permanent deformation of materials under constant load at high temperature. It is critical in turbines, boilers, and engines. Creep failure occurs slowly but catastrophically, so materials must be carefully selected.''',
    deepExplanation: '''Creep has three stages: primary (decreasing rate), secondary (steady rate), tertiary (rapid failure). Temperature > 0.3–0.4 Tm (melting point). Alloys like nickel, stainless steel resist creep. Engineers must analyze creep rate, stress rupture curves, and allowable stress.

Example
Steam turbine blades deforming after long service.

Mistakes
Confusing creep with fatigue


Tips
Mention Larson–Miller parameter.


Resources
Callister – High Temperature Materials''',
  ),
  QuestionItem(
    id: 'CORE-Q17',
    industry: 'Core Engineering',
    topic: 'Circuit Breaker',
    question: '''What is a Circuit Breaker? Explain its types.
(Asked at: ABB, Siemens)''',
    shortAnswer: '''A circuit breaker automatically interrupts current during faults. It protects devices, cables, and people. Types include MCB, MCCB, ACB, VCB, and SF6 breakers. Selection depends on voltage, current, and application.''',
    deepExplanation: '''MCB → low current/household.
 MCCB → high current/industries.
 ACB → up to 1kV switchgear.
 VCB → medium voltage, long life.
 SF6 → high voltage, arc quenching.
 Breakers operate using thermal-magnetic or electronic trip units. Fault detection triggers opening of contacts.

Example
11 kV VCB in substations.

Mistakes
Calling fuse a breaker (wrong)


Tips
Mention arc quenching mediums.


Resources
NPTEL Power System Protection''',
  ),
  QuestionItem(
    id: 'CORE-Q18',
    industry: 'Core Engineering',
    topic: 'Segregation and Bleeding',
    question: '''What is Segregation and Bleeding in Concrete?
(Asked at: Civil Site, QA/QC roles)''',
    shortAnswer: '''Segregation is separation of coarse aggregate from the mix, while bleeding is upward movement of water. Both weaken concrete, reduce strength, and cause surface defects. Proper mix design and compaction prevent these issues.''',
    deepExplanation: '''Segregation occurs due to excessive vibration, poor mix proportion, or dropping concrete from height. Bleeding occurs when water rises, leaving pores and weak layers. Using proper water–cement ratio, admixtures, and controlled placement ensures quality. IS 456 specifies limits.

Example
Concrete slab showing water on top after placement.

Mistakes
Adding extra water on-site


Tips
Use plasticizers instead of excess water.


Resources
IS 456, Neville’s Concrete Technology''',
  ),
  QuestionItem(
    id: 'CORE-Q19',
    industry: 'Core Engineering',
    topic: 'IC Engine Working',
    question: '''Explain Working of an Internal Combustion Engine.
(Asked at: Tata Motors, Ashok Leyland)''',
    shortAnswer: '''IC engines convert chemical energy of fuel into mechanical work through combustion inside the cylinder. Intake, compression, power, and exhaust strokes drive piston motion, which rotates the crankshaft. Engine efficiency depends on combustion, compression ratio, and heat loss control.''',
    deepExplanation: '''Air-fuel mixture burns rapidly → high pressure → piston forced downward. Spark ignition (petrol) vs compression ignition (diesel). Turbochargers increase air intake → more power. Cooling, lubrication, and valve timing ensure smooth operation.

Example
4-stroke car engine producing torque.

Mistakes
Saying diesel uses spark plug (wrong)


Tips
Mention compression ratio difference.


Resources
I.C Engine by V. Ganeshan''',
  ),
  QuestionItem(
    id: 'CORE-Q20',
    industry: 'Core Engineering',
    topic: 'Load Duration Curve',
    question: '''What is a Load Duration Curve in Power Systems?
(Asked at: Tata Power, NTPC)''',
    shortAnswer: '''A load duration curve plots system load versus time arranged in descending order. It helps utilities determine base load, peak load, and plant sizing. It shows how often certain load levels occur.''',
    deepExplanation: '''Base load plants (coal, nuclear) run continuously. Peak load plants (gas turbines) run only during high demand. LDC helps plan capacity, tariffs, energy storage, and reliability. It is crucial for forecasting and economic dispatch.

Example
Summer peak curve showing high evening loads.

Mistakes
Confusing LDC with load curve (chronological).


Tips
Mention economic load dispatch.


Resources
NPTEL Power Systems Planning''',
  ),
  QuestionItem(
    id: 'CORE-Q21',
    industry: 'Core Engineering',
    topic: 'Brittle vs Ductile',
    question: '''What is the Difference Between Brittle and Ductile Materials?
(Asked at: Tata Steel, SAIL, L&T)''',
    shortAnswer: '''Ductile materials deform significantly before fracture (large strain), while brittle materials break suddenly with little deformation. Ductile materials show a clear yield point; brittle ones do not. Ductile behavior is preferred for structures because it gives warnings before failure.''',
    deepExplanation: '''Ductile materials: steel, aluminum → high tensile strength, large plastic region.
 Brittle materials: cast iron, glass → low toughness, fracture without warning.
 In earthquakes, ductile design prevents catastrophic collapse. In mechanical design, ductility influences safety factors, weldability, forging, and impact resistance.

Example
Steel rod bends before breaking; glass shatters instantly.

Mistakes
Believing brittle = weak (cast iron is strong but brittle)


Tips
Always mention impact tests (Charpy/Izod)


Resources
Callister — Mechanical Behavior of Materials''',
  ),
  QuestionItem(
    id: 'CORE-Q22',
    industry: 'Core Engineering',
    topic: 'Eddy Current Loss',
    question: '''What is Eddy Current Loss?
(Asked at: Siemens, ABB, Transformers QA)''',
    shortAnswer: '''Eddy current loss occurs when alternating magnetic flux induces circulating currents inside a transformer core or motor. These currents waste energy as heat. Laminated steel cores reduce eddy currents by increasing resistance and limiting current paths.''',
    deepExplanation: '''Induced EMF inside the core creates closed-loop currents (eddy currents).
 Power loss ∝ (flux density)² × frequency² × thickness².
 To reduce losses:
Use thin laminations


High-resistivity core (CRGO steel)


Use ferrites at high frequency


Lower eddy losses → higher efficiency.

Example
Transformers use 0.3–0.5 mm laminations.

Mistakes
Mixing up eddy current loss with hysteresis loss.


Tips
Mention Steinmetz equation for total core loss.


Resources
Electrical Machines — Nagrath & Kothari''',
  ),
  QuestionItem(
    id: 'CORE-Q23',
    industry: 'Core Engineering',
    topic: 'Cantilever Beam',
    question: '''What is a Cantilever Beam? State real-life applications.
(Asked at: Civil Core Roles, L&T Construction)''',
    shortAnswer: '''A cantilever beam is fixed at one end and free at the other. It supports loads without external bracing by resisting bending and shear. Examples include balconies, traffic signal poles, and aircraft wings.''',
    deepExplanation: '''Cantilever beams carry load through compression in upper fibers and tension in lower fibers (opposite for downward load). They must resist large bending moments at the fixed end. RCC design requires proper reinforcement (steel bars in tension zone). Stability checks include deflection limits and overturning moments.

Example
Balcony slab projecting 1.5m from wall.

Mistakes
Incorrect reinforcement placement.


Tips
Always sketch SFD/BMD if asked.


Resources
Hibbeler — Structural Analysis''',
  ),
  QuestionItem(
    id: 'CORE-Q24',
    industry: 'Core Engineering',
    topic: 'Brayton Cycle',
    question: '''What is a Brayton Cycle?
(Asked at: Gas Turbine, Thermal Plant Interviews)''',
    shortAnswer: '''The Brayton cycle is the thermodynamic cycle used in gas turbines. It involves isentropic compression, constant-pressure heat addition, isentropic expansion, and constant-pressure heat rejection. It powers aircraft engines and gas power plants.''',
    deepExplanation: '''Compressor → Combustion chamber → Turbine.
 Efficiency increases with pressure ratio and turbine inlet temperature. Regeneration, intercooling, and reheating further improve performance. Used in jet propulsion because it provides continuous high power with lightweight components.

Example
Jet engine powering Airbus/Boeing aircraft.

Mistakes
Confusing with Otto or Diesel cycles.


Tips
Always mention regeneration for bonus points.


Resources
Cengel Thermodynamics — Brayton cycle''',
  ),
  QuestionItem(
    id: 'CORE-Q25',
    industry: 'Core Engineering',
    topic: 'Reinforcement in Concrete',
    question: '''What is the Purpose of Reinforcement in Concrete?
(Asked at: RCC Design, Structural Interview)''',
    shortAnswer: '''Reinforcement (steel bars) provides tensile strength to concrete, which is otherwise weak in tension. It carries tension forces, resists cracking, and increases ductility and durability. RCC combines concrete’s compressive strength with steel’s tensile capacity.''',
    deepExplanation: '''Concrete cracks under tension at just ~2–3 MPa, while steel withstands 250–500 MPa. Steel and concrete bond well and have similar thermal expansion coefficients. Reinforcement types: main bars, stirrups, ties, distribution bars. Proper detailing prevents shear failure and buckling.

Example
Beams reinforced with top and bottom bars.

Mistakes
Using too much cover → corrosion risk.


Tips
Mention IS 456 reinforcement rules.


Resources
IS 456, SP-16''',
  ),
  QuestionItem(
    id: 'CORE-Q26',
    industry: 'Core Engineering',
    topic: 'Harmonic Distortion',
    question: '''What is Harmonic Distortion?
(Asked at: Electrical maintenance, industrial roles)''',
    shortAnswer: '''Harmonics are unwanted multiples of fundamental AC frequency. They distort the waveform, cause overheating, reduce efficiency, trip equipment, and damage sensitive electronics. Non-linear loads like VFDs and UPS systems produce harmonics.''',
    deepExplanation: '''THD (Total Harmonic Distortion) quantifies distortion.
 Problems include:
Overheating of transformers


Neutral conductor overload


Poor PF


Reduced motor torque


Mitigation: filters, isolation transformers, 12-pulse rectifiers.

Example
DC drives injecting 5th and 7th harmonics.

Mistakes
Thinking harmonics = noise.


Tips
Mention IEEE 519 limits.


Resources
IEEE 519 Harmonic Standards''',
  ),
  QuestionItem(
    id: 'CORE-Q27',
    industry: 'Core Engineering',
    topic: 'Thermal Conductivity',
    question: '''Define Thermal Conductivity. Which materials have high/low values?
(Asked at: Materials, HVAC, heat transfer roles)''',
    shortAnswer: '''Thermal conductivity (k) measures how easily heat flows through a material. Metals like copper and aluminum have high conductivity; insulation materials like wool, foam, and air have low conductivity.''',
    deepExplanation: '''Heat conduction follows Fourier’s law.
 q = –kA(dT/dx)
 High-k materials used in heat exchangers; low-k materials in insulation and building envelopes. Understanding k helps design boilers, HVAC ducts, refrigeration systems, and building thermal performance.

Example
Copper tube used in air conditioners.

Mistakes
Confusing conductivity with heat capacity.


Tips
Always quote real-world usage.


Resources
Cengel Heat Transfer''',
  ),
  QuestionItem(
    id: 'CORE-Q28',
    industry: 'Core Engineering',
    topic: 'Dead Loads vs Live Loads',
    question: '''What are Dead Loads and Live Loads?
(Asked at: Civil site & structural roles)''',
    shortAnswer: '''Dead loads are permanent loads like self-weight of structural members. Live loads are temporary, movable loads like people, furniture, vehicles, or wind. Structures are designed for both based on IS 875.''',
    deepExplanation: '''Dead load: weight of slab, beam, walls.
 Live load: occupancy, machinery load.
 Load combinations ensure safety under worst-case conditions. Lateral loads like wind and earthquake are separate categories. Incorrect load estimation leads to structural failure.

Example
Dead load: 25 kN/m² for RCC floor.
 Live load: 3 kN/m² for residential.

Mistakes
Ignoring dynamic loads.


Tips
Mention IS 875 (Part 1 & 2).


Resources
IS 875 Load Code''',
  ),
  QuestionItem(
    id: 'CORE-Q29',
    industry: 'Core Engineering',
    topic: 'PID Controller',
    question: '''What is a PID Controller?
(Asked at: Automation, process engineering roles)''',
    shortAnswer: '''A PID controller uses Proportional, Integral, and Derivative control actions to maintain a process variable at a set point. It minimizes error in systems like temperature, pressure, speed, and flow control.''',
    deepExplanation: '''P → corrects present error
 I → corrects past accumulated error
 D → predicts future error
 Tuning (Ziegler–Nichols) ensures stability. P-only may oscillate; PI improves accuracy; PID gives best response. Used in boilers, HVAC, motors, robotics.

Example
Maintaining 120°C in a steam jacket.

Mistakes
Over-tuning leading to oscillation.


Tips
Mention auto-tuning in modern PLCs.


Resources
Ogata — Control Systems''',
  ),
  QuestionItem(
    id: 'CORE-Q30',
    industry: 'Core Engineering',
    topic: 'Welding Defects',
    question: '''What is a Welding Defect? Name common types.
(Asked at: Mechanical fabrication, QA roles)''',
    shortAnswer: '''Welding defects are imperfections that reduce weld strength or quality. Common defects include porosity, cracks, slag inclusion, incomplete penetration, undercut, and distortion. These defects weaken joints and reduce reliability.''',
    deepExplanation: '''Causes include moisture, wrong electrode, poor technique, incorrect heat input, and improper cleaning. Inspection uses visual tests, ultrasonic testing (UT), radiography, dye penetrant. Correct heat control and joint preparation reduce defects.

Example
Porosity in MIG weld due to gas contamination.

Mistakes
Welding without preheat on thick sections.


Tips
Mention NDT (UT, RT, MT, PT).


Resources
AWS Welding Handbook''',
  ),
  QuestionItem(
    id: 'CORE-Q31',
    industry: 'Core Engineering',
    topic: 'Fatigue Failure',
    question: '''What is Fatigue Failure? How is it different from Static Failure?
(Asked at: Tata Motors, L&T Mechanical, JSW Steel)''',
    shortAnswer: '''Fatigue failure occurs due to repeated cyclic loading, even when stresses are below yield strength. It starts with microscopic crack initiation, then propagation, leading to sudden fracture. Static failure happens under a single application of load exceeding material strength.''',
    deepExplanation: '''Fatigue happens because fluctuating stress causes microcracks at stress concentrations (holes, fillets, welds). S–N curves (Wöhler curves) determine fatigue life. Endurance limit exists for some steels but not for aluminum. Fatigue failure is dangerous because it occurs without warning, unlike ductile static failure. Engineers must design fillets, keyways, shafts, and rotating parts considering fatigue factors.

Example
Aircraft wings, turbine blades, rotating shafts.

Mistakes
Confusing fatigue with creep.


Tips
Always mention S–N curve & stress concentration factor.


Resources
Machine Design by Shigley — Fatigue Chapter''',
  ),
  QuestionItem(
    id: 'CORE-Q32',
    industry: 'Core Engineering',
    topic: 'Relay',
    question: '''What is a Relay? How is it used in protection?
(Asked at: Siemens, ABB, Substation panels)''',
    shortAnswer: '''A relay is an electrically operated switch that senses abnormal conditions and sends a trip signal to breakers. Protective relays detect overcurrent, earth faults, differential faults, and isolate faulty sections to protect equipment.''',
    deepExplanation: '''Types: electromechanical, solid-state, numerical relays.
 Numerical relays use microprocessors for precise detection and multi-protection (overcurrent, under-voltage, reverse power). Relays coordinate with breakers to maintain system stability. Settings depend on fault levels, CT ratios, and protection zones.

Example
Overcurrent relay tripping 11kV feeder during short-circuit.

Mistakes
Wrong relay coordination.


Tips
Mention modern SCADA integration.


Resources
Power System Protection — Badri Ram & Vishwakarma''',
  ),
  QuestionItem(
    id: 'CORE-Q33',
    industry: 'Core Engineering',
    topic: 'Workability of Concrete',
    question: '''What is Workability of Concrete? How is it measured?
(Asked at: L&T Civil, UltraTech)''',
    shortAnswer: '''Workability refers to how easily concrete can be mixed, placed, compacted, and finished. It depends on water content, aggregate shape, and admixtures. It is measured by tests like slump test, compaction factor, and Vee-Bee.''',
    deepExplanation: '''Higher workability needed for congested reinforcement; lower for pavements. Too much water leads to segregation and lower strength. Chemical admixtures (plasticizers, superplasticizers) improve workability without increasing water–cement ratio. IS 1199 covers test procedures.

Example
Slump of 75–100 mm for beams/columns.

Mistakes
Adding water at construction site (weakens mix).


Tips
Quote IS 456 recommendations.


Resources
Neville’s Concrete Technology''',
  ),
  QuestionItem(
    id: 'CORE-Q34',
    industry: 'Core Engineering',
    topic: 'Shear Strength of Soil',
    question: '''Explain Shear Strength of Soil.
(Asked at: Geotechnical roles, Civil site interviews)''',
    shortAnswer: '''Shear strength is the maximum resistance soil offers against sliding. It depends on cohesion, internal friction, and normal stress. It determines foundation size, slope stability, and retaining wall design.''',
    deepExplanation: '''Mohr–Coulomb equation:
 τ = c + σ tan φ
 Where c = cohesion, φ = angle of internal friction.
 Tests include: direct shear, triaxial, unconfined compression. Shear strength varies with moisture content, compaction, drainage, and soil type (clay vs sand). Inadequate shear strength leads to landslides and foundation failure.

Example
Clay has high cohesion; sand has high friction.

Mistakes
Assuming shear strength is constant (varies with conditions).


Tips
Mention drained vs undrained tests.


Resources
Soil Mechanics by B.C. Punmia''',
  ),
  QuestionItem(
    id: 'CORE-Q35',
    industry: 'Core Engineering',
    topic: 'Heat Exchanger',
    question: '''What is a Heat Exchanger? Name common types.
(Asked at: Thermal plants, Process engineering)''',
    shortAnswer: '''A heat exchanger transfers heat between two fluids without mixing them. Common types are shell-and-tube, plate, finned, double-pipe, and air-cooled exchangers. They are used in power plants, refineries, HVAC, and automobiles.''',
    deepExplanation: '''Heat transfer depends on flow arrangement (parallel, counterflow, crossflow). Shell-and-tube exchangers handle high pressure/temperature; plate exchangers offer compact design and high efficiency. Fouling reduces performance and requires cleaning. LMTD and effectiveness-NTU methods calculate performance.

Example
Radiator in a car engine.

Mistakes
Confusing LMTD with temperature difference at outlet.


Tips
Mention counterflow advantage (higher ΔT).


Resources
Cengel Heat Transfer — Heat Exchangers''',
  ),
  QuestionItem(
    id: 'CORE-Q36',
    industry: 'Core Engineering',
    topic: 'Power System Stability',
    question: '''What is Power System Stability?
(Asked at: PowerGrid, NTPC, HV roles)''',
    shortAnswer: '''Power system stability is the ability of a power system to maintain synchronism and return to steady operation after a disturbance. It includes rotor angle stability, voltage stability, and frequency stability.''',
    deepExplanation: '''Disturbances include faults, generator trips, and sudden load changes. Rotor angle stability deals with synchronous generator behavior; voltage stability deals with reactive power balance; frequency stability deals with power imbalance. FACTS devices, AVR, governor control, and system protection improve stability.

Example
Grid remains stable after a 200MW generator trip.

Mistakes
Treating stability as only frequency.


Tips
Mention transient stability study.


Resources
NPTEL Power System Dynamics''',
  ),
  QuestionItem(
    id: 'CORE-Q37',
    industry: 'Core Engineering',
    topic: 'Modulus of Elasticity',
    question: '''What is Modulus of Elasticity? Why is it important?
(Asked at: Mechanical & Civil core roles)''',
    shortAnswer: '''Modulus of elasticity (E) measures a material’s stiffness—the ratio of stress to strain in the elastic region. High E means the material resists deformation. It is critical in designing beams, columns, shafts, and machine components.''',
    deepExplanation: '''E determines deflection, vibration characteristics, and load-bearing capacity. Steel (E ≈ 200 GPa) is stiffer than aluminum (70 GPa). Concrete has a lower and variable modulus. In structural engineering, deflection limits depend on E; in mechanical systems, shaft stiffness depends on E.

Example
Steel beam deflects less than aluminum under same load.

Mistakes
Thinking E changes with load (constant until yield).


Tips
Mention Hooke’s law.


Resources
Strength of Materials — Timoshenko''',
  ),
  QuestionItem(
    id: 'CORE-Q38',
    industry: 'Core Engineering',
    topic: 'Earthing Transformer',
    question: '''What is Earthing Transformer?
(Asked at: Substation & Power Roles)''',
    shortAnswer: '''An earthing transformer provides a ground reference for ungrounded systems, enabling zero-sequence current flow during faults. Zig-zag or star–delta configurations are used. It ensures stable voltage during earth faults.''',
    deepExplanation: '''Ungrounded systems face issues during single-line-to-ground faults. Earthing transformer provides a neutral point for grounding. Zig-zag type cancels phase voltages, creating neutral. They limit fault current using resistors (NER). Essential in wind farms, solar plants, and industrial substations.

Example
Used in 33kV solar plant to provide grounding.

Mistakes
Confusing with distribution transformer.


Tips
Mention NER (Neutral Earthing Resistor).


Resources
IEC 60076 Standards''',
  ),
  QuestionItem(
    id: 'CORE-Q39',
    industry: 'Core Engineering',
    topic: 'Prestressed Concrete',
    question: '''What is Prestressed Concrete?
(Asked at: Bridges, metro projects, L&T Infrastructure)''',
    shortAnswer: '''Prestressed concrete applies compressive force to concrete before load application. Since concrete is weak in tension, prestressing counteracts tensile stresses. It allows longer spans, thinner sections, and crack-free structures.''',
    deepExplanation: '''Techniques: pre-tensioning (factory cast) and post-tensioning (site cast). High-strength steel tendons are tensioned to compress concrete. Used in bridges, metro viaducts, flyovers, railway sleepers. Prestressing improves durability and reduces material usage.

Example
Metro elevated viaduct segments are prestressed.

Mistakes
Thinking prestressing = reinforcement (different concepts).


Tips
Mention tendon layout and anchorage.


Resources
IS 1343: Prestressed Concrete Code''',
  ),
  QuestionItem(
    id: 'CORE-Q40',
    industry: 'Core Engineering',
    topic: 'Entropy',
    question: '''What is Entropy?
(Asked at: Thermal, Chemical, Mechanical design roles)''',
    shortAnswer: '''Entropy measures disorder or energy unavailable for useful work. It increases in natural processes and indicates irreversibility. Higher entropy → lower efficiency in real engines, compressors, and turbines.''',
    deepExplanation: '''Entropy helps evaluate cycle efficiency. Real processes generate entropy due to friction, mixing, heat transfer across temperature differences. Carnot efficiency is theoretical because real systems always produce entropy. T–S diagrams visualize entropy change during cycles (Rankine, Brayton, refrigeration).

Example
Heat transfer at large ΔT produces high entropy.

Mistakes
Saying entropy = “randomness” without context.


Tips
Always link entropy to irreversibility.


Resources
Cengel Thermodynamics — Entropy Chapter''',
  ),
  QuestionItem(
    id: 'CORE-Q41',
    industry: 'Core Engineering',
    topic: 'Dynamic Balancing',
    question: '''What is Dynamic Balancing in Rotating Machinery?
(Asked at: Tata Motors, JSW, Mechanical maintenance roles)''',
    shortAnswer: '''Dynamic balancing ensures a rotating body has no unbalanced mass that causes vibration during rotation. Unlike static balancing, dynamic balancing considers rotation in two planes. Proper balancing increases machine life, reduces noise, and prevents bearing failure.''',
    deepExplanation: '''Unbalance causes centrifugal forces that increase with RPM (F = m·r·ω²). Dynamic balancing uses vibration analyzers to detect imbalance in heavy rotors, fans, and turbines. Correction is done by adding/removing mass or drilling holes. ISO standards specify balance quality grades.

Example
Balancing of a car wheel or turbine rotor.

Mistakes
Thinking static balance = dynamic balance.


Balancing only at low RPM.


Tips
Mention FFT vibration analysis.


Resources
Machinery Vibration — Bently & Hatch''',
  ),
  QuestionItem(
    id: 'CORE-Q42',
    industry: 'Core Engineering',
    topic: 'Lightning Arrester',
    question: '''What is a Lightning Arrester?
(Asked at: PowerGrid, Electrical Substation roles)''',
    shortAnswer: '''A lightning arrester diverts high-voltage lightning surges safely to the ground, protecting equipment. MOV (Metal Oxide Varistor) arresters are common. Installed at substations, transmission lines, and building entry points.''',
    deepExplanation: '''Lightning causes transient overvoltages that damage insulators, transformers, and electronics. Arresters provide low impedance during surges, high impedance otherwise. They clamp voltage to a safe level. Surge counters monitor performance.

Example
11kV surge arrester installed near transformer HV bushing.

Mistakes
Confusing surge arrester with earthing.


Tips
Mention insulation coordination.


Resources
IEC 60099 Standards''',
  ),
  QuestionItem(
    id: 'CORE-Q43',
    industry: 'Core Engineering',
    topic: 'Bearing Capacity',
    question: '''What is Bearing Capacity of Soil?
(Asked at: Civil—Foundation engineering roles)''',
    shortAnswer: '''Bearing capacity is the maximum load per unit area that soil can support without shear failure. It determines the size and type of foundation. Safe bearing capacity includes factors of safety to prevent settlement.''',
    deepExplanation: '''Terzaghi’s formula gives ultimate bearing capacity for different soil types. Factors influencing bearing capacity: soil type, water table, footing shape, depth. Tests: plate load test, SPT, CPT. Poor bearing capacity → piles or raft foundations.

Example
Sandy soil: higher bearing capacity than clay.

Mistakes
Not accounting for water table rise.


Tips
Mention safety factor (typically 2.5–3).


Resources
Soil Mechanics — Terzaghi & Peck''',
  ),
  QuestionItem(
    id: 'CORE-Q44',
    industry: 'Core Engineering',
    topic: 'Boiler Draught',
    question: '''Explain Boiler Draught. Why is it required?
(Asked at: NTPC, Thermal power roles)''',
    shortAnswer: '''Boiler draught is the pressure difference required to supply air for combustion and remove flue gases. It ensures continuous airflow. Draught can be natural (chimney) or mechanical (fans).''',
    deepExplanation: '''Natural draught uses temperature difference in chimney. Mechanical draught uses forced-draft (FD), induced-draft (ID), or balanced-draft fans. Proper draught ensures efficient combustion, prevents smoke, maintains flame stability, and controls furnace pressure.

Example
Large power plants use ID + FD fans.

Mistakes
Assuming natural draught is sufficient for high-capacity boilers.


Tips
Mention balanced draught for efficiency.


Resources
Thermal Engineering — R.K. Rajput''',
  ),
  QuestionItem(
    id: 'CORE-Q45',
    industry: 'Core Engineering',
    topic: 'Short Circuit',
    question: '''What is a Short Circuit? Types of faults?
(Asked at: Electrical Protection jobs)''',
    shortAnswer: '''A short circuit occurs when current flows through a low-resistance unintended path. It causes high current, heating, equipment damage. Types: L–L, L–G, L–L–G, 3-phase faults. Protection uses relays and breakers.''',
    deepExplanation: '''Caused by insulation failure, mechanical damage, moisture. Fault currents can reach tens of kA, requiring proper fault level calculation. Sequence components help analyze unbalanced faults. Breakers, CTs, isolators coordinate protection zones.

Example
11kV feeder tripping due to line-to-ground fault.

Mistakes
Confusing short-circuit with overload.


Tips
Mention symmetrical vs unsymmetrical faults.


Resources
Power System Protection — Badri Ram''',
  ),
  QuestionItem(
    id: 'CORE-Q46',
    industry: 'Core Engineering',
    topic: 'Flywheel',
    question: '''What is a Flywheel? Why is it used?
(Asked at: Mechanical—Automotive, Machine design roles)''',
    shortAnswer: '''A flywheel stores rotational energy and smoothens torque fluctuations in engines and machines. It stabilizes speed during cyclic loads and improves efficiency. In IC engines, it maintains uniform crankshaft rotation.''',
    deepExplanation: '''Engines produce intermittent power (power stroke only). Flywheel absorbs energy during power stroke and releases it during non-power strokes. Moment of inertia determines storage. Used in presses, punching machines, energy recovery systems.

Example
Flywheel in a 4-stroke engine.

Mistakes
Thinking flywheel increases power (it only stabilizes).


Tips
Mention J = m·r² (inertia dependence).


Resources
Machine Design — Bhandari''',
  ),
  QuestionItem(
    id: 'CORE-Q47',
    industry: 'Core Engineering',
    topic: 'Circuit Basics',
    question: '''What is a Circuit? Explain Series vs Parallel.
(Asked at: Freshers—Electrical Basics)''',
    shortAnswer: '''A circuit is a closed path for current flow. In series circuits, components share the same current but divide voltage. In parallel circuits, components share voltage but split current. Series failure breaks entire circuit; parallel failure affects only one branch.''',
    deepExplanation: '''Series: R_eq = R1 + R2;
 Parallel: 1/R_eq = 1/R1 + 1/R2.
 Series circuits used for protection; parallel for reliability. Parallel circuits reduce total resistance, series increase it. Understanding circuits is essential for designing panels, motors, and electronics.

Example
House wiring uses parallel connection.

Mistakes
Thinking bulbs glow dimmer in parallel (opposite).


Tips
Mention KCL/KVL basics.


Resources
Basic Electrical Engineering — Fitzgerald''',
  ),
  QuestionItem(
    id: 'CORE-Q48',
    industry: 'Core Engineering',
    topic: 'Segmentation in Columns',
    question: '''What is Segmentation and why is it used in RCC Columns?
(Asked at: Structural roles)''',
    shortAnswer: '''Segmentation divides long RCC columns into manageable casting heights using construction joints. It ensures proper compaction, prevents cold joints, and improves quality control on site.''',
    deepExplanation: '''Tall columns (>3 m) are difficult to vibrate properly. Segmentation ensures concrete does not segregate. Horizontal construction joints are placed at beam levels. They must be roughened and cleaned before next pour. IS 456 provides guidelines.

Example
G+10 building using segmented column casting.

Mistakes
Pouring too high at once → honeycombing.


Tips
Always clean joints before re-casting.


Resources
IS 456''',
  ),
  QuestionItem(
    id: 'CORE-Q49',
    industry: 'Core Engineering',
    topic: 'Refrigeration Cycle',
    question: '''What is Refrigeration Cycle? Explain its components.
(Asked at: HVAC, mechanical design roles)''',
    shortAnswer: '''The refrigeration cycle transfers heat from low temperature to high temperature using work input. It includes evaporator, compressor, condenser, and expansion valve. Refrigerant absorbs heat in evaporator and releases it in condenser.''',
    deepExplanation: '''Compressor increases pressure & temperature. Condenser rejects heat to surroundings. Expansion valve drops pressure. Evaporator absorbs heat—cooling effect. Performance measured by COP. Refrigerant selection considers ODP, GWP, flammability.

Example
Household AC uses vapor compression cycle.

Mistakes
Confusing condenser and evaporator roles.


Tips
Mention R-32, R-410A common refrigerants.


Resources
Refrigeration & Air Conditioning — C.P. Arora''',
  ),
  QuestionItem(
    id: 'CORE-Q50',
    industry: 'Core Engineering',
    topic: 'Retaining Wall',
    question: '''What is a Retaining Wall? Why is Backfilling Important?
(Asked at: Civil construction roles)''',
    shortAnswer: '''A retaining wall holds back soil to prevent lateral movement. Backfilling with proper material and drainage prevents pressure buildup, cracking, and failure. It ensures wall stability and longevity.''',
    deepExplanation: '''Types: gravity, cantilever, counterfort. Walls resist active earth pressure. Poor drainage → hydrostatic pressure → failure. Backfill must be granular, compacted layer-wise, with weep holes or drainage pipes. Design uses Rankine or Coulomb theories.

Example
Retaining walls on highways or basement construction.

Mistakes
Backfilling with clay (holds water).


Tips
Mention weep holes for drainage.


Resources
Punmia — Foundation Engineering''',
  ),
];
