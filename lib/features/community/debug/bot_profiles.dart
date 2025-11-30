enum BotBehaviorType {
  specialist, // mostly own industry
  explorer,   // sometimes cross-industry
  generalist, // browses everything
}

class BotProfile {
  final String id;
  final String displayName; // Renamed from 'name' to avoid conflict if any, but 'name' is fine too. Using displayName for clarity.
  final String role;
  final String industryTag;
  final BotBehaviorType behaviorType;
  final double likeBias; // Probability to like a relevant post
  final double commentBias; // Probability to comment on a relevant post

  const BotProfile({
    required this.id,
    required this.displayName,
    required this.role,
    required this.industryTag,
    required this.behaviorType,
    this.likeBias = 0.3,
    this.commentBias = 0.1,
  });
}

// Master list of 100 bots
final List<BotProfile> allBots = _generateBots();

List<BotProfile> botsForIndustry(String industryTag) =>
    allBots.where((b) => b.industryTag == industryTag).toList();

List<BotProfile> _generateBots() {
  final bots = <BotProfile>[];
  
  // 1. IT & Software (25 bots)
  bots.addAll(_createIndustryBots(
    industryTag: 'IT & Software',
    count: 25,
    roles: [
      "Senior Backend Engineer", "SDE-2", "Cloud Architect", "Fresher Dev", 
      "Tech Lead", "Hiring Manager (IT)", "DevOps Engineer", "Frontend Dev",
      "QA Automation Lead", "Product Manager", "CTO", "Intern"
    ],
    names: _itNames,
  ));

  // 2. Sales & Marketing (25 bots)
  bots.addAll(_createIndustryBots(
    industryTag: 'Sales & Marketing',
    count: 25,
    roles: [
      "Sales Trainer", "Marketing Manager", "SDR Lead", "Fresher - Sales", 
      "Brand Strategist", "HR (Sales)", "Digital Marketing Exec", "B2B Sales Head",
      "Content Strategist", "SEO Specialist", "VP of Sales", "Intern"
    ],
    names: _salesNames,
  ));

  // 3. BPO & Support (25 bots)
  bots.addAll(_createIndustryBots(
    industryTag: 'BPO & Support',
    count: 25,
    roles: [
      "Team Lead - BPO", "Customer Support Rep", "Quality Analyst", "Process Trainer", 
      "HR (BPO)", "Ops Manager", "Voice Process Agent", "Chat Support Lead",
      "Technical Support", "Client Success Mgr", "Shift Manager", "Fresher"
    ],
    names: _bpoNames,
  ));

  // 4. Core Engineering (25 bots)
  bots.addAll(_createIndustryBots(
    industryTag: 'Core Engineering',
    count: 25,
    roles: [
      "Mechanical Design Engineer", "Civil Site Engineer", "Electrical Engineer", 
      "Fresher - Core", "Plant Manager", "HR (Core)", "Project Engineer", 
      "Safety Officer", "AutoCAD Designer", "Maintenance Head", "R&D Engineer", "Intern"
    ],
    names: _coreNames,
  ));

  return bots;
}

List<BotProfile> _createIndustryBots({
  required String industryTag,
  required int count,
  required List<String> roles,
  required List<String> names,
}) {
  final generated = <BotProfile>[];
  
  for (int i = 0; i < count; i++) {
    // Distribute behavior: 60% specialist, 30% explorer, 10% generalist
    BotBehaviorType type;
    if (i < 15) {
      type = BotBehaviorType.specialist;
    } else if (i < 22) { // 15 + 7 = 22 (approx 30%)
      type = BotBehaviorType.explorer;
    } else {
      type = BotBehaviorType.generalist;
    }

    final name = names[i % names.length];
    final role = roles[i % roles.length];
    
    // Unique ID
    final id = 'bot_${industryTag.replaceAll(' ', '_').toLowerCase()}_$i';

    generated.add(BotProfile(
      id: id,
      displayName: name,
      role: role,
      industryTag: industryTag,
      behaviorType: type,
      likeBias: 0.2 + (i % 5) * 0.05, // Varied 0.2 - 0.4
      commentBias: 0.05 + (i % 3) * 0.05, // Varied 0.05 - 0.15
    ));
  }
  return generated;
}

// --- Name Pools ---

const _itNames = [
  "Aarav Sharma", "Vihaan Gupta", "Aditya Patel", "Sai Kumar", "Reyansh Singh",
  "Arjun Reddy", "Krishna Iyer", "Ishaan Verma", "Shaurya Das", "Rohan Mehta",
  "Ananya Rao", "Diya Nair", "Saanvi Malhotra", "Myra Kapoor", "Aadhya Joshi",
  "Priya Jain", "Kavya Choudhury", "Neha Agarwal", "Riya Saxena", "Meera Bhat",
  "Rahul Deshmukh", "Vikram Singh", "Amit Trivedi", "Suresh Menon", "Pooja Hegde"
];

const _salesNames = [
  "Kabir Khan", "Aryan Mishra", "Vivaan Joshi", "Dhruv Pandey", "Atharv Kaur",
  "Advik Shetty", "Samarth Pillai", "Ayaan Ghosh", "Vihaan Chatterjee", "Yuvan Sinha",
  "Kiara Fernandez", "Fatima Sheikh", "Zoya Siddiqui", "Amaira D'Souza", "Saira Banu",
  "Nisha Yadav", "Sneha Roy", "Tanvi Thakur", "Zara Merchant", "Pari Sethi",
  "Rajeev Kumar", "Sunil Dutt", "Deepak Chopra", "Anita Desai", "Simran Kaur"
];

const _bpoNames = [
  "Mohammed Ali", "Ibrahim Khan", "Yusuf Ahmed", "Bilal Sheikh", "Omar Farooq",
  "Hamza Siddiqui", "Mustafa Qureshi", "Abdullah Baig", "Hassan Raza", "Ali Reza",
  "Ayesha Khan", "Mariam Bibi", "Zainab Fatima", "Sara Ahmed", "Hafsa Begum",
  "Noor Jahan", "Sana Mir", "Hina Rabbani", "Sadia Khan", "Farah Naz",
  "John Doe", "Jane Smith", "Michael Brown", "Emily Davis", "Chris Wilson" 
];

const _coreNames = [
  "Siddharth Rao", "Gautam Menon", "Pranav Nair", "Nikhil Reddy", "Harsh Vardhan",
  "Yashwant Singh", "Kunal Kapoor", "Manish Tiwari", "Rajesh Kumar", "Sanjay Gupta",
  "Lakshmi Narayan", "Sita Ram", "Gita Devi", "Radha Krishna", "Parvati Patil",
  "Indira Gandhi", "Sarojini Naidu", "Kalpana Chawla", "Sunita Williams", "Rani Laxmibai",
  "Ashok Leyland", "Tata Motors", "Maruti Suzuki", "Hyundai India", "Mahindra Rise"
];
