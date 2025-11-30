import 'question_model.dart';

const List<QuestionItem> itQuestions = [
  QuestionItem(
    id: 'IT-Q1',
    industry: 'IT & Software',
    topic: 'Array + Hashing',
    question: '''Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target. Assume exactly one solution exists and you may not use the same element twice.''',
    shortAnswer: '''Use a hash map to store each value and its index while iterating the array. For each element x, check if target - x is already in the map. If yes, return the pair of indices. This runs in O(n) time and O(n) space, much better than the brute-force O(n²) approach.''',
    deepExplanation: '''Why this is asked:
 This question tests whether the candidate:
Recognizes the brute-force double loop (O(n²))


Can optimize using auxiliary data structures (hash map)


Understands trade-offs in time vs. space


Approach:
Initialize an empty hash map value → index.


Loop over indices i from 0 to n - 1:


Let current = nums[i]


Compute need = target - current


If need exists in map → you found nums[i] + nums[map[need]] = target


Return [map[need], i].


If loop completes without a pair (in variants where no guarantee exists), return an error / empty result.


Why hash map works well:
Lookup for need is O(1) average-case.


You only pass through the array once → O(n) time.


This pattern “store what you’ve seen, check for complement” appears in many problems (Two Sum, subarray sums, etc.).


Example
nums = [2, 7, 11, 15], target = 9


i=0: current=2, need=7 → map={} → store {2:0}


i=1: current=7, need=2 → map has 2 → indices [0,1]


C++ Solution
#include <vector>
#include <unordered_map>
using namespace std;

vector<int> twoSum(vector<int>& nums, int target) {
    unordered_map<int, int> mp; // value -> index
    for (int i = 0; i < (int)nums.size(); i++) {
        int need = target - nums[i];
        if (mp.find(need) != mp.end()) {
            return {mp[need], i};
        }
        mp[nums[i]] = i;
    }
    return {}; // in problem constraints, this won't be hit
}

Python Solution
from typing import List

def two_sum(nums: List[int], target: int) -> List[int]:
    mp = {}  # value -> index
    for i, x in enumerate(nums):
        need = target - x
        if need in mp:
            return [mp[need], i]
        mp[x] = i
    return []

Time & Space Complexity
Time: O(n)


Space: O(n) for the hash map


Common Mistakes
Using nested loops (O(n²)) when an optimal O(n) solution is expected.


Returning values instead of indices (when problem clearly asks for indices).


Not handling negative numbers or duplicates properly.


Tips for Interviews
Explicitly say: “Brute force is O(n²). With a hash map we can reduce it to O(n).”


Draw a small example to show how the map evolves.


Mention that hash map lookups are average-case O(1).


Recommended Resources
Search: “LeetCode Two Sum”


Search: “GeeksforGeeks Two Sum problem”


Search: “Hashing for array problems – GFG article”''',
  ),
  QuestionItem(
    id: 'IT-Q2',
    industry: 'IT & Software',
    topic: 'Array, Single Pass',
    question: '''You are given an array prices where prices[i] is the price of a stock on day i. You want to maximize profit by choosing a single day to buy and a different day in the future to sell. Return the maximum profit, or 0 if no profit is possible.''',
    shortAnswer: '''Track the minimum price so far and the maximum profit so far in one pass. For each price, update the minimum if the price is lower, otherwise compute potential profit price - minSoFar and update the max profit if it’s higher. This gives O(n) time and O(1) space.''',
    deepExplanation: '''Why this is asked:
Tests pattern: “track best-so-far + current value”.


Helps interviewers see if candidate can optimize beyond brute force.


Naive Approach:
For every pair i<j compute prices[j] - prices[i] → O(n²).


Not acceptable for large inputs.


Optimal Approach:
Initialize:


minPrice = +∞


maxProfit = 0


Iterate from left to right:


For each price:


Update minPrice = min(minPrice, price)


Compute potential profit price - minPrice


Update maxProfit = max(maxProfit, price - minPrice)


At the end, maxProfit is the result.


Example
prices = [7, 1, 5, 3, 6, 4]
min=∞, profit=0


price=7 → min=7, profit=0


price=1 → min=1, profit=0


price=5 → potential=4 → maxProfit=4


price=3 → potential=2 → maxProfit=4


price=6 → potential=5 → maxProfit=5


price=4 → potential=3 → maxProfit=5


Answer: 5 (buy at 1, sell at 6).
C++ Solution
#include <vector>
#include <climits>
using namespace std;

int maxProfit(vector<int>& prices) {
    int minPrice = INT_MAX;
    int maxProfit = 0;
    for (int p : prices) {
        if (p < minPrice) {
            minPrice = p;
        } else {
            maxProfit = max(maxProfit, p - minPrice);
        }
    }
    return maxProfit;
}

Python Solution
from typing import List

def max_profit(prices: List[int]) -> int:
    min_price = float('inf')
    max_profit = 0
    for p in prices:
        if p < min_price:
            min_price = p
        else:
            max_profit = max(max_profit, p - min_price)
    return max_profit

Complexity
Time: O(n)


Space: O(1)


Common Mistakes
Allowing buying after selling (wrong index ordering).


Trying to track multiple buys/sells when the question clearly says “one transaction”.


Not considering that profit can be 0 (if prices always decrease).


Tips
Clearly state “we only need one pass”.


Mention that this is a classic “max difference after this point” pattern.


Resources
Search: “LeetCode Best Time to Buy and Sell Stock I”


Search: “Kadane’s algorithm variant – stock buy and sell”''',
  ),
  QuestionItem(
    id: 'IT-Q3',
    industry: 'IT & Software',
    topic: 'Array, DP',
    question: '''Given an integer array nums, find the contiguous subarray with the largest sum and return its sum.''',
    shortAnswer: '''Use Kadane’s algorithm: maintain a running current sum and a global maximum. For each number, decide whether to start a new subarray or extend the existing one. This is done in O(n) time and O(1) space.''',
    deepExplanation: '''Kadane’s algorithm is a dynamic programming approach without explicit DP arrays.
Idea:
For each index i, we compute currentMax = the maximum sum of a subarray ending at i.


Recurrence:


currentMax = max(nums[i], currentMax + nums[i])


Global answer is the maximum currentMax seen so far.


The intuition is:
If the previous running sum becomes negative, it will only harm the next element, so we drop it and start fresh.


Example
nums = [-2,1,-3,4,-1,2,1,-5,4]
Walkthrough:
Start: current = -2, global = -2


num=1 → max(1, -2+1= -1) → 1; global=1


num=-3 → max(-3, 1-3= -2) → -2; global=1


num=4 → max(4, -2+4=2) → 4; global=4


num=-1 → max(-1, 4-1=3) → 3; global=4


num=2 → max(2, 3+2=5) → 5; global=5


num=1 → max(1, 5+1=6) → 6; global=6


num=-5 → max(-5, 6-5=1) → 1; global=6


num=4 → max(4, 1+4=5) → 5; global=6


Answer: 6 (subarray [4,-1,2,1]).
C++ Solution
#include <vector>
#include <climits>
using namespace std;

int maxSubArray(vector<int>& nums) {
    int currentMax = nums[0];
    int globalMax = nums[0];
    for (int i = 1; i < (int)nums.size(); i++) {
        currentMax = max(nums[i], currentMax + nums[i]);
        globalMax = max(globalMax, currentMax);
    }
    return globalMax;
}

Python Solution
from typing import List

def max_sub_array(nums: List[int]) -> int:
    current_max = nums[0]
    global_max = nums[0]
    for x in nums[1:]:
        current_max = max(x, current_max + x)
        global_max = max(global_max, current_max)
    return global_max

Complexity
Time: O(n)


Space: O(1)


Common Mistakes
Initializing currentMax or globalMax to 0 instead of the first element (fails for all-negative arrays).


Forgetting to handle negative numbers correctly.


Tips
Always mention: “Works even if all numbers are negative.”


Connect this to “max profit” style problems (same idea of running best-so-far).


Resources
Search: “Kadane’s Algorithm GFG”


Search: “LeetCode Maximum Subarray”''',
  ),
  QuestionItem(
    id: 'IT-Q4',
    industry: 'IT & Software',
    topic: 'Array, Two Pointers',
    question: '''You are given two sorted integer arrays nums1 and nums2, and integers m and n, where nums1 has length m + n with the last n positions reserved (0s) to accommodate nums2. Merge nums2 into nums1 in non-decreasing order in-place.''',
    shortAnswer: '''Start from the end of both arrays and fill nums1 from the back. Use three pointers: i = m-1, j = n-1, k = m+n-1. At each step, place the larger of nums1[i] or nums2[j] at nums1[k].''',
    deepExplanation: '''The trick is to avoid overwriting elements in nums1 that haven’t been placed yet.
If we merged from the front, we’d need extra space.
 By merging from the back, we always place the largest remaining element at the end.
Algorithm:
i = m - 1 (end of nums1’s real values)


j = n - 1 (end of nums2)


k = m + n - 1 (end of nums1’s total capacity)


While i >= 0 and j >= 0:


If nums1[i] > nums2[j] → nums1[k] = nums1[i], i--


Else → nums1[k] = nums2[j], j--


k--


Copy remaining nums2 if any (while (j >= 0)).


C++ Solution
#include <vector>
using namespace std;

void merge(vector<int>& nums1, int m, vector<int>& nums2, int n) {
    int i = m - 1;
    int j = n - 1;
    int k = m + n - 1;
    while (i >= 0 && j >= 0) {
        if (nums1[i] > nums2[j]) {
            nums1[k--] = nums1[i--];
        } else {
            nums1[k--] = nums2[j--];
        }
    }
    while (j >= 0) {
        nums1[k--] = nums2[j--];
    }
}

Python Solution
from typing import List

def merge(nums1: List[int], m: int, nums2: List[int], n: int) -> None:
    i, j, k = m - 1, n - 1, m + n - 1
    while i >= 0 and j >= 0:
        if nums1[i] > nums2[j]:
            nums1[k] = nums1[i]
            i -= 1
        else:
            nums1[k] = nums2[j]
            j -= 1
        k -= 1

    while j >= 0:
        nums1[k] = nums2[j]
        j -= 1
        k -= 1

Complexity
Time: O(m + n)


Space: O(1) in-place


Common Mistakes
Merging from the front (overwrites elements).


Forgetting to copy remaining nums2 when i < 0 but j >= 0.


Tips
Emphasize in-place nature.


Draw arrays visually to show back-filling.


Resources
Search: “LeetCode Merge Sorted Array”


Search: “Two-pointer technique for array problems”''',
  ),
  QuestionItem(
    id: 'IT-Q5',
    industry: 'IT & Software',
    topic: 'Strings + Hashing',
    question: '''Given two strings s and t, determine if t is an anagram of s. You may assume lowercase English letters.''',
    shortAnswer: '''Count the frequency of each character in s and subtract the frequency for t. If all counts are zero at the end, they are anagrams. You can use an array of size 26 for lowercase letters.''',
    deepExplanation: '''Idea:
 Two strings are anagrams if:
They have the same length.


Each character appears the same number of times.


Steps:
If len(s) != len(t) → return false.


Create an array freq[26] initialized to 0.


For each char c in s → freq[c - 'a']++.


For each char c in t → freq[c - 'a']--.


If any freq[i] != 0 → not an anagram.


Alternatively, we can sort both strings and compare, but that’s O(n log n). The counting method is O(n).
C++ Solution
#include <string>
#include <vector>
using namespace std;

bool isAnagram(string s, string t) {
    if (s.size() != t.size()) return false;
    vector<int> freq(26, 0);
    for (char c : s) freq[c - 'a']++;
    for (char c : t) freq[c - 'a']--;
    for (int x : freq) {
        if (x != 0) return false;
    }
    return true;
}

Python Solution
def is_anagram(s: str, t: str) -> bool:
    if len(s) != len(t):
        return False
    freq = [0] * 26
    for c in s:
        freq[ord(c) - ord('a')] += 1
    for c in t:
        freq[ord(c) - ord('a')] -= 1
    return all(x == 0 for x in freq)

Complexity
Time: O(n)


Space: O(1) (26-length array)


Common Mistakes
Not checking length first.


Using maps for lowercase-only case (array is simpler and faster).


Tips
Mention both solutions (sorting vs counting) and explain trade-off.


Resources
Search: “LeetCode Valid Anagram”


Search: “Character frequency array technique”''',
  ),
  QuestionItem(
    id: 'IT-Q6',
    industry: 'IT & Software',
    topic: 'Two Pointers',
    question: '''Given a sorted array of integers and a target value, find two numbers such that they add up to the target. Return 1-based indices of the two numbers.''',
    shortAnswer: '''Use two pointers, one at the start and one at the end. If the sum is too small, move the left pointer right. If too large, move the right pointer left. This uses the sorted property to achieve O(n) time.''',
    deepExplanation: '''Why two pointers work:
 Because the array is sorted:
If nums[left] + nums[right] < target → we need a larger sum → move left++.


If sum > target → move right--.


If sum == target → done.


This pattern is widely used for:
Pair sum problems


3-sum, 4-sum (with nesting)


Windowing and searching patterns


C++ Solution
#include <vector>
using namespace std;

vector<int> twoSumSorted(vector<int>& nums, int target) {
    int l = 0, r = (int)nums.size() - 1;
    while (l < r) {
        int sum = nums[l] + nums[r];
        if (sum == target) {
            return {l + 1, r + 1};
        } else if (sum < target) {
            l++;
        } else {
            r--;
        }
    }
    return {};
}

Python Solution
from typing import List

def two_sum_sorted(nums: List[int], target: int) -> List[int]:
    l, r = 0, len(nums) - 1
    while l < r:
        s = nums[l] + nums[r]
        if s == target:
            return [l + 1, r + 1]
        elif s < target:
            l += 1
        else:
            r -= 1
    return []

Complexity
Time: O(n)


Space: O(1)


Common Mistakes
Ignoring that array is sorted and using extra hash map unnecessarily.


Returning 0-based indices when problem demands 1-based.


Tips
Explicitly say: “The sort property lets us avoid hashing and use two pointers.”


Resources
Search: “LeetCode Two Sum II Input array is sorted”''',
  ),
  QuestionItem(
    id: 'IT-Q7',
    industry: 'IT & Software',
    topic: 'Linked List',
    question: '''Given the head of a linked list, determine if the linked list has a cycle.''',
    shortAnswer: '''Use Floyd’s cycle detection algorithm: maintain a slow pointer (moves 1 step) and a fast pointer (moves 2 steps). If they ever meet, there is a cycle; if fast or fast->next becomes null, there is no cycle.''',
    deepExplanation: '''Why this matters:
 Cycle detection appears in:
Linked lists


Graphs


Functional iteration detection


Algorithm (Floyd’s Tortoise and Hare):
slow = head, fast = head


While fast and fast->next are not null:


slow = slow->next


fast = fast->next->next


If slow == fast → cycle exists.


If loop ends, no cycle.


Intuition:
 If there is a cycle, fast pointer eventually “laps” slow pointer (like two runners on a circular track).
C++ Solution
struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(nullptr) {}
};

bool hasCycle(ListNode *head) {
    if (!head || !head->next) return false;
    ListNode* slow = head;
    ListNode* fast = head;
    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) return true;
    }
    return false;
}

Python Solution
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

def has_cycle(head: ListNode) -> bool:
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False

Complexity
Time: O(n)


Space: O(1)


Common Mistakes
Forgetting to check fast and fast->next for null.


Trying to use a set (extra space O(n)) when O(1) solution exists (still acceptable, but less elegant).


Tips
Mention that storing visited nodes in a hash set also works but uses more memory.


For follow-up, you can also find the start of the cycle with a known trick.


Resources
Search: “LeetCode Linked List Cycle”


Search: “Floyd’s Tortoise and Hare algorithm explanation”''',
  ),
  QuestionItem(
    id: 'IT-Q8',
    industry: 'IT & Software',
    topic: 'Linked List manipulation',
    question: '''Reverse a singly linked list and return the new head.''',
    shortAnswer: '''Use three pointers: prev, curr, next. Traverse the list, at each step redirect curr->next to prev, then move all pointers one step forward. Return prev as the new head.''',
    deepExplanation: '''Why this is core:
 It tests:
Pointer manipulation


Understanding of node structure


Comfort with iterative logic


Algorithm:
Initialize prev = null, curr = head.


While curr is not null:


next = curr->next


curr->next = prev


prev = curr


curr = next


At the end, prev is the new head.


C++ Solution
ListNode* reverseList(ListNode* head) {
    ListNode* prev = nullptr;
    ListNode* curr = head;
    while (curr) {
        ListNode* nxt = curr->next;
        curr->next = prev;
        prev = curr;
        curr = nxt;
    }
    return prev;
}

Python Solution
def reverse_list(head: ListNode) -> ListNode:
    prev = None
    curr = head
    while curr:
        nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    return prev

Complexity
Time: O(n)


Space: O(1)


Common Mistakes
Losing reference to the rest of the list (forgetting to store next first).


Creating new nodes unnecessarily instead of reversing in-place.


Tips
Always draw a small 3-node example in mind.


In system design interviews, mention reversing partial lists, k-groups, etc as extensions.


Resources
Search: “LeetCode Reverse Linked List”''',
  ),
  QuestionItem(
    id: 'IT-Q9',
    industry: 'IT & Software',
    topic: 'Stack, Strings',
    question: '''Given a string containing just the characters ()[]{}, determine if the input string is valid. A string is valid if open brackets are closed by the same type of brackets and in the correct order.''',
    shortAnswer: '''Use a stack. For every opening bracket, push it; for every closing bracket, check the top of the stack for the matching opening type. If mismatch or stack is empty, invalid. At the end, stack must be empty.''',
    deepExplanation: '''Key idea:
 LIFO (Last In First Out) structure → stack is perfect for matching nested structures.
Algorithm:
Use a stack of chars.


Traverse string:


If char is opening bracket → push.


If closing:


If the stack is empty → invalid.


Pop top; if it doesn’t match the correct opening pair → invalid.


At the end, if the stack is empty → valid.


C++ Solution
#include <stack>
#include <string>
using namespace std;

bool isValid(string s) {
    stack<char> st;
    for (char c : s) {
        if (c == '(' || c == '{' || c == '[') {
            st.push(c);
        } else {
            if (st.empty()) return false;
            char top = st.top(); st.pop();
            if ((c == ')' && top != '(') ||
                (c == '}' && top != '{') ||
                (c == ']' && top != '[')) {
                return false;
            }
        }
    }
    return st.empty();
}

Python Solution
def is_valid_parentheses(s: str) -> bool:
    stack = []
    pairs = {')': '(', '}': '{', ']': '['}
    for c in s:
        if c in '([{':
            stack.append(c)
        else:
            if not stack or stack[-1] != pairs.get(c, ''):
                return False
            stack.pop()
    return len(stack) == 0

Complexity
Time: O(n)


Space: O(n) in worst-case (all openings)


Common Mistakes
Forgetting to check for empty stack before popping.


Not checking at the end if stack is empty.


Tips
Mention that this pattern generalizes to HTML/XML tag matching.


Resources
Search: “LeetCode Valid Parentheses”''',
  ),
  QuestionItem(
    id: 'IT-Q10',
    industry: 'IT & Software',
    topic: 'Binary Search',
    question: '''Given a sorted array of integers and a target value, return the index if the target is found. If not, return -1.''',
    shortAnswer: '''Use binary search: maintain low and high pointers. At each step, compute mid, compare nums[mid] with target, and shrink search space accordingly until low > high.''',
    deepExplanation: '''Binary search is fundamental for logarithmic-time lookups on sorted data.
Algorithm:
low = 0, high = n - 1.


While low <= high:


mid = low + (high - low) / 2.


If nums[mid] == target → return mid.


Else if nums[mid] < target → low = mid + 1.


Else → high = mid - 1.


Return -1 if not found.


Key idea:
 Each step halves the search space → O(log n).
C++ Solution
#include <vector>
using namespace std;

int binarySearch(const vector<int>& nums, int target) {
    int low = 0, high = (int)nums.size() - 1;
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (nums[mid] == target) return mid;
        else if (nums[mid] < target) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}

Python Solution
from typing import List

def binary_search(nums: List[int], target: int) -> int:
    low, high = 0, len(nums) - 1
    while low <= high:
        mid = low + (high - low) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

Complexity
Time: O(log n)


Space: O(1)


Common Mistakes
Using (low + high) / 2 directly (can overflow in some languages; the safer version is low + (high - low) / 2).


Incorrect loop condition (low < high instead of <= can miss elements).


Tips
Explicitly mention complexity and why it’s O(log n).


For bonus, mention variants:


first occurrence, last occurrence, lower_bound, upper_bound.


Resources
Search: “Binary search templates LeetCode”


Search: “Lower bound vs upper bound in C++ STL”''',
  ),
  QuestionItem(
    id: 'IT-Q11',
    industry: 'IT & Software',
    topic: 'Array',
    question: '''Given an integer array nums, return an array output where output[i] = product of all elements except nums[i], without using division and in O(n) time.''',
    shortAnswer: '''Use two passes:
First pass builds a prefix product for each index.


Second pass builds a suffix product from the right.
 Multiply prefix[i] * suffix[i] to get the result.
 This avoids division and works even with zeros.''',
    deepExplanation: '''This question evaluates whether a candidate can think in terms of precomputation patterns.
Brute force:
 For each index, compute product of all others → O(n²). Not acceptable.
Optimal approach:
 A number at index i should get:
product_except_i = (product of elements left of i)
                  * (product of elements right of i)

We compute:
prefix[i] = product of nums[0…i-1]


suffix[i] = product of nums[i+1…n-1]


Then multiply them.
This trick teaches:
Breaking a problem into precomputed left & right states


Avoiding division (because of zeros)



C++ Solution
vector<int> productExceptSelf(vector<int>& nums) {
    int n = nums.size();
    vector<int> res(n, 1);

    int prefix = 1;
    for (int i = 0; i < n; i++) {
        res[i] = prefix;
        prefix *= nums[i];
    }

    int suffix = 1;
    for (int i = n - 1; i >= 0; i--) {
        res[i] *= suffix;
        suffix *= nums[i];
    }

    return res;
}

Python Solution
def product_except_self(nums):
    n = len(nums)
    res = [1]*n

    prefix = 1
    for i in range(n):
        res[i] = prefix
        prefix *= nums[i]

    suffix = 1
    for i in range(n-1, -1, -1):
        res[i] *= suffix
        suffix *= nums[i]

    return res


Complexity
Time: O(n)


Space: O(1) extra (excluding output)



Common Mistakes
Using division (fails when zeros present)


Forgetting prefix or suffix start values (must be 1)


Creating unnecessary extra arrays



Tips
Mention “division is disallowed due to zeros and integer rounding issues”.


Explain prefix-suffix as a general reusable pattern.



Resources
Search “LeetCode Product of Array Except Self”


GFG article on prefix-suffix technique''',
  ),
  QuestionItem(
    id: 'IT-Q12',
    industry: 'IT & Software',
    topic: 'Binary Search',
    question: '''Given a sorted array and a target value, return the index if the target is found.
 If not, return the index where it would be inserted to maintain order.''',
    shortAnswer: '''Use binary search. If the element is not found, return low where binary search stops. That position indicates where the target should be inserted.''',
    deepExplanation: '''This builds directly on binary search fundamentals:
Binary search stops when low > high.
 At that moment:
All numbers < target are on left of low


All numbers ≥ target are on right


Thus insertion point = low.
Example:
nums=[1,3,5,6], target=5 → returns 2


target=2 → would be inserted at index 1 → binary search returns 1


target=7 → inserted at index 4



C++ Solution
int searchInsert(vector<int>& nums, int target) {
    int low = 0, high = nums.size() - 1;
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (nums[mid] == target) return mid;
        else if (nums[mid] < target) low = mid + 1;
        else high = mid - 1;
    }
    return low;
}

Python Solution
def search_insert(nums, target):
    low, high = 0, len(nums)-1
    while low <= high:
        mid = (low + high)//2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return low


Complexity
Time: O(log n)


Space: O(1)



Common Mistakes
Returning -1 if not found (incorrect).


Confusing insertion position with mid index.



Tips
Mention that insertion sort and lower_bound use same logic.



Resources
Search: “LeetCode Search Insert Position”''',
  ),
  QuestionItem(
    id: 'IT-Q13',
    industry: 'IT & Software',
    topic: 'Hash Map (String Key)',
    question: '''Given an array of strings, group the anagrams together.''',
    shortAnswer: '''Use a hash map where the key is the sorted version of the string and the value is a list of original strings. Sorting ensures all anagrams map to the same key.''',
    deepExplanation: '''Two words are anagrams if:
They contain the exact same characters


In the exact same frequency


Sorting each string arranges characters in lexicographical order.
 All anagrams → same sorted representation.
Example:
"eat", "tea", "ate" → key "aet"


"bat", "tab" → key "abt"


Alternate method:
 Use a 26-length character count array as key.
Sorting approach complexity: O(N * K log K), where K is string length.

C++ Solution
vector<vector<string>> groupAnagrams(vector<string>& strs) {
    unordered_map<string, vector<string>> mp;
    for (auto& s : strs) {
        string key = s;
        sort(key.begin(), key.end());
        mp[key].push_back(s);
    }
    vector<vector<string>> res;
    for (auto& p : mp) res.push_back(p.second);
    return res;
}

Python Solution
from collections import defaultdict, 

def group_anagrams(strs):
    mp = defaultdict(list)
    for s in strs:
        key = ''.join(sorted(s))
        mp[key].append(s)
    return list(mp.values())


Complexity
Time: O(n * k log k)


Space: O(n * k)



Common Mistakes
Using character frequency dict in Python but forgetting order of keys.


Forgetting to convert character counts to a hashable tuple.



Tips
Mention both sorted-string and frequency-array approaches.



Resources
Search: “LeetCode Group Anagrams”''',
  ),
  QuestionItem(
    id: 'IT-Q14',
    industry: 'IT & Software',
    topic: 'DP – Classic',
    question: '''You are climbing a staircase with n steps. You can take either 1 step or 2 steps at a time. How many distinct ways can you reach the top?''',
    shortAnswer: '''The number of ways follows Fibonacci logic: ways[n] = ways[n-1] + ways[n-2]. Use dynamic programming to compute iteratively.''',
    deepExplanation: '''Let f(n) be the number of ways to climb n steps:
To reach step n, you could come from:


(n-1) using a 1-step


(n-2) using a 2-step


Thus:
f(n) = f(n-1) + f(n-2)

Base cases:
f(1)=1


f(2)=2


This is literally the Fibonacci sequence starting from these seeds.
You can optimize space using two variables.

C++ Solution
int climbStairs(int n) {
    if (n <= 2) return n;
    int a = 1, b = 2;
    for (int i = 3; i <= n; i++) {
        int c = a + b;
        a = b;
        b = c;
    }
    return b;
}

Python Solution
def climb_stairs(n):
    if n <= 2:
        return n
    a, b = 1, 2
    for _ in range(3, n+1):
        a, b = b, a + b
    return b


Complexity
Time: O(n)


Space: O(1)



Common Mistakes
Using recursion without memoization → exponential time


Incorrect base cases



Tips
In interviews, mention the space optimization.



Resources
Search: “LeetCode Climbing Stairs”''',
  ),
  QuestionItem(
    id: 'IT-Q15',
    industry: 'IT & Software',
    topic: 'Array – Rotation',
    question: '''Rotate an array of length n to the right by k steps. For example:
 nums = [1,2,3,4,5,6,7], k = 3 → output: [5,6,7,1,2,3,4].''',
    shortAnswer: '''Normalize k = k % n. Reverse the entire array, then reverse the first k elements, then reverse the remaining n-k elements. This works because reversing twice restores the order around the rotation point.''',
    deepExplanation: '''Why reverse technique works:
 Reverse operations reorganize the array efficiently:
For n=7, k=3:
Original: [1 2 3 4 5 6 7]
 Step 1 → Reverse all: [7 6 5 4 3 2 1]
 Step 2 → Reverse first k: [5 6 7 4 3 2 1]
 Step 3 → Reverse remaining: [5 6 7 1 2 3 4]
This eliminates needing extra space or shifting elements one-by-one.

C++ Solution
void reverse(vector<int>& nums, int l, int r) {
    while (l < r) swap(nums[l++], nums[r--]);
}

void rotate(vector<int>& nums, int k) {
    int n = nums.size();
    k %= n;
    reverse(nums, 0, n-1);
    reverse(nums, 0, k-1);
    reverse(nums, k, n-1);
}

Python Solution
def rotate(nums, k):
    n = len(nums)
    k %= n
    nums.reverse()
    nums[:k] = reversed(nums[:k])
    nums[k:] = reversed(nums[k:])


Complexity
Time: O(n)


Space: O(1)



Common Mistakes
Forgetting k %= n.


Rotating left instead of right.


Using extra array unnecessarily.



Tips
Draw the reverse steps if the interviewer asks “why this works”.



Resources
Search: “LeetCode Rotate Array Reverse Method”''',
  ),
  QuestionItem(
    id: 'IT-Q16',
    industry: 'IT & Software',
    topic: 'Hashing',
    question: '''Given an array, determine if any value appears at least twice.''',
    shortAnswer: '''Use a hash set. Insert each element; if it already exists, return true.''',
    deepExplanation: '''This tests understanding of hash-based lookups.
Approach:
Create an empty set.


Iterate through array:


If element exists → duplicate


Else insert into set


Return false if loop ends with no duplicate.


Alternate approach: sort array then check adjacent elements.

C++ Solution
bool containsDuplicate(vector<int>& nums) {
    unordered_set<int> st;
    for (int x : nums) {
        if (st.count(x)) return true;
        st.insert(x);
    }
    return false;
}

Python Solution
def contains_duplicate(nums):
    seen = set()
    for x in nums:
        if x in seen:
            return True
        seen.add(x)
    return False


Complexity
Time: O(n)


Space: O(n)



Tips
Mention sorting alternative (O(n log n)).''',
  ),
  QuestionItem(
    id: 'IT-Q17',
    industry: 'IT & Software',
    topic: 'Bit Manipulation / Math',
    question: '''Given nums containing n numbers from 0 to n, find the missing number.''',
    shortAnswer: '''Use XOR of all numbers from 0 to n and XOR with all elements in nums. XOR cancels out duplicates, leaving the missing number.''',
    deepExplanation: '''Why XOR works:
a ^ a = 0


a ^ 0 = a
 Thus:


missing = (0 ^ 1 ^ 2 ^ ... ^ n) 
          XOR
          (nums[0] ^ nums[1] ^ ... ^ nums[n-1])

Only the missing number remains.
Alternate method:
 Use formula: sum_n = n*(n+1)/2

C++ Solution
int missingNumber(vector<int>& nums) {
    int xorAll = 0, xorArr = 0, n = nums.size();
    for (int i = 0; i <= n; i++) xorAll ^= i;
    for (int x : nums) xorArr ^= x;
    return xorAll ^ xorArr;
}

Python Solution
def missing_number(nums):
    xor_all = 0
    xor_arr = 0
    n = len(nums)
    for i in range(n+1):
        xor_all ^= i
    for x in nums:
        xor_arr ^= x
    return xor_all ^ xor_arr


Complexity
Time: O(n)


Space: O(1)''',
  ),
  QuestionItem(
    id: 'IT-Q18',
    industry: 'IT & Software',
    topic: 'Set Operation',
    question: '''Return the intersection of two arrays.''',
    shortAnswer: '''Convert one array to a set, then check which elements of the other array exist in the set.''',
    deepExplanation: '''This is a direct application of set membership operations (O(1) average).
 Avoid duplicates in output by using a second set.
Example:
nums1 = [1,2,2,1], nums2=[2,2] → output=[2]

C++ Solution
vector<int> intersection(vector<int>& a, vector<int>& b) {
    unordered_set<int> st(a.begin(), a.end());
    unordered_set<int> res;
    for (int x : b)
        if (st.count(x)) res.insert(x);
    return vector<int>(res.begin(), res.end());
}

Python Solution
def intersection(a, b):
    return list(set(a) & set(b))''',
  ),
  QuestionItem(
    id: 'IT-Q19',
    industry: 'IT & Software',
    topic: 'String',
    question: '''Find the longest common prefix among an array of strings.''',
    shortAnswer: '''Compare characters column-wise or sort the list and compare the first and last strings (since sorting brings closest words together).''',
    deepExplanation: '''Sorting technique:
After sorting:
First string = smallest lexicographically


Last string = largest


Longest common prefix between them equals LCP of entire set.
Example:
 ["flower","flow","flight"]
 Sorted → ["flight","flow","flower"]
 LCP("flight", "flower") = "fl"

C++ Solution
string longestCommonPrefix(vector<string>& strs) {
    sort(strs.begin(), strs.end());
    string a = strs[0], b = strs.back();
    int i = 0;
    while (i < a.size() && i < b.size() && a[i] == b[i]) i++;
    return a.substr(0, i);
}

Python Solution
def longest_common_prefix(strs):
    strs.sort()
    a, b = strs[0], strs[-1]
    i = 0
    while i < len(a) and i < len(b) and a[i] == b[i]:
        i += 1
    return a[:i]''',
  ),
  QuestionItem(
    id: 'IT-Q20',
    industry: 'IT & Software',
    topic: 'Interval Processing',
    question: '''Given intervals, merge all overlapping intervals.''',
    shortAnswer: '''Sort intervals by start time, then iterate and merge whenever the current interval overlaps with the previous merged one.''',
    deepExplanation: '''Define overlap as:
if current.start <= previous.end

Then merge them by:
previous.end = max(previous.end, current.end)


C++ Solution
vector<vector<int>> merge(vector<vector<int>>& intervals) {
    sort(intervals.begin(), intervals.end());
    vector<vector<int>> res;
    for (auto& it : intervals) {
        if (res.empty() || res.back()[1] < it[0])
            res.push_back(it);
        else
            res.back()[1] = max(res.back()[1], it[1]);
    }
    return res;
}

Python Solution
def merge_intervals(intervals):
    intervals.sort()
    res = []
    for it in intervals:
        if not res or res[-1][1] < it[0]:
            res.append(it)
        else:
            res[-1][1] = max(res[-1][1], it[1])
    return res''',
  ),
  QuestionItem(
    id: 'IT-Q21',
    industry: 'IT & Software',
    topic: 'Interval manipulation',
    question: '''Insert a new interval into a list of sorted, non-overlapping intervals and merge if needed.''',
    shortAnswer: '''Iterate intervals:
Add all intervals ending before new interval starts


Merge overlapping ones


Add remaining intervals''',
    deepExplanation: '''C++ Solution
vector<vector<int>> insertInterval(vector<vector<int>>& intervals, vector<int>& ni) {
    vector<vector<int>> res;
    int i = 0, n = intervals.size();
    
    while (i < n && intervals[i][1] < ni[0]) 
        res.push_back(intervals[i++]);
    
    while (i < n && intervals[i][0] <= ni[1]) {
        ni[0] = min(ni[0], intervals[i][0]);
        ni[1] = max(ni[1], intervals[i][1]);
        i++;
    }
    res.push_back(ni);
    
    while (i < n) res.push_back(intervals[i++]);
    
    return res;
}

Python Solution
def insert_interval(intervals, ni):
    res = []
    i = 0
    n = len(intervals)

    while i < n and intervals[i][1] < ni[0]:
        res.append(intervals[i])
        i += 1

    while i < n and intervals[i][0] <= ni[1]:
        ni[0] = min(ni[0], intervals[i][0])
        ni[1] = max(ni[1], intervals[i][1])
        i += 1

    res.append(ni)

    while i < n:
        res.append(intervals[i])
        i += 1

    return res''',
  ),
  QuestionItem(
    id: 'IT-Q22',
    industry: 'IT & Software',
    topic: 'String, Two Pointers',
    question: '''Determine if a string is a palindrome, considering only alphanumeric characters and ignoring cases.''',
    shortAnswer: '''Use two pointers. Move inward from both sides, skip non-alphanumeric characters, compare lowercase versions.''',
    deepExplanation: '''Steps:
Preprocess by ignoring non-alphanumeric characters.


Compare characters at left and right.


If mismatch → not palindrome.


Otherwise continue.


Example:
 "A man, a plan, a canal: Panama" → valid.

C++ Solution
bool isPalindrome(string s) {
    int l = 0, r = s.size()-1;
    while (l < r) {
        while (l < r && !isalnum(s[l])) l++;
        while (l < r && !isalnum(s[r])) r--;
        if (tolower(s[l]) != tolower(s[r])) return false;
        l++; r--;
    }
    return true;
}

Python Solution
def is_palindrome(s):
    l, r = 0, len(s)-1
    while l < r:
        while l < r and not s[l].isalnum():
            l += 1
        while l < r and not s[r].isalnum():
            r -= 1
        if s[l].lower() != s[r].lower():
            return False
        l += 1
        r -= 1
    return True''',
  ),
  QuestionItem(
    id: 'IT-Q23',
    industry: 'IT & Software',
    topic: 'Hash Sets, Grid Validation',
    question: '''Determine if a 9×9 Sudoku board is valid (not necessarily solvable), ensuring no duplicates in rows, columns, or 3×3 sub-boxes.''',
    shortAnswer: '''Use three sets for each row, column, and sub-box. Insert each number and fail if already present.''',
    deepExplanation: '''Track three 2D structures:
rows[9][9]


cols[9][9]


boxes[9][9]


Box index:
 box = (r/3)*3 + (c/3)
If any number violates rules → invalid.

C++ Solution
bool isValidSudoku(vector<vector<char>>& board) {
    vector<vector<bool>> rows(9, vector<bool>(9, false));
    vector<vector<bool>> cols(9, vector<bool>(9, false));
    vector<vector<bool>> box(9, vector<bool>(9, false));

    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            if (board[r][c] == '.') continue;
            int num = board[r][c] - '1';
            int b = (r/3)*3 + (c/3);
            if (rows[r][num] || cols[c][num] || box[b][num])
                return false;
            rows[r][num] = cols[c][num] = box[b][num] = true;
        }
    }
    return true;
}

Python Solution
def is_valid_sudoku(board):
    rows = [[False]*9 for _ in range(9)]
    cols = [[False]*9 for _ in range(9)]
    box = [[False]*9 for _ in range(9)]

    for r in range(9):
        for c in range(9):
            if board[r][c] == '.':
                continue
            num = ord(board[r][c]) - ord('1')
            b = (r//3)*3 + (c//3)
            if rows[r][num] or cols[c][num] or box[b][num]:
                return False
            rows[r][num] = cols[c][num] = box[b][num] = True

    return True''',
  ),
  QuestionItem(
    id: 'IT-Q24',
    industry: 'IT & Software',
    topic: 'Trees',
    question: '''Given the root of a binary tree, determine if it is a valid Binary Search Tree (BST).''',
    shortAnswer: '''Perform an inorder traversal; if the resulting list is strictly increasing, it is a valid BST.''',
    deepExplanation: '''A BST must satisfy:
left < root < right

And must hold for every node, not just children.
Inorder traversal of BST gives sorted order.
 Check if every element is greater than the previous one.
Alternate solution: recursion with min/max bounds.

Python-ish Pseudocode
function inorder(node):
    if node is null: return
    inorder(node.left)
    check current value > last value seen
    inorder(node.right)


C++ Solution
long prev = LONG_MIN;
bool isValidBST(TreeNode* root) {
    return validate(root);
}

bool validate(TreeNode* node) {
    if (!node) return true;
    if (!validate(node->left)) return false;
    if (node->val <= prev) return false;
    prev = node->val;
    return validate(node->right);
}

Python Solution
def is_valid_bst(root):
    prev = float('-inf')
    valid = True

    def inorder(node):
        nonlocal prev, valid
        if not node or not valid:
            return
        inorder(node.left)
        if node.val <= prev:
            valid = False
        prev = node.val
        inorder(node.right)

    inorder(root)
    return valid''',
  ),
  QuestionItem(
    id: 'IT-Q25',
    industry: 'IT & Software',
    topic: 'Tree Depth, Recursion',
    question: '''Given a binary tree, return the length of the diameter, defined as the number of edges in the longest path between any two nodes.''',
    shortAnswer: '''Height of a node = 1 + max(leftHeight, rightHeight).
 Diameter = max of:
leftDiameter


rightDiameter


leftHeight + rightHeight''',
    deepExplanation: '''This is a classic combined recursion problem.
 At each node, compute:
Height


Best diameter


Diameter might pass through the root or lie entirely in one subtree.

C++ Solution
int ans = 0;

int height(TreeNode* root) {
    if (!root) return 0;
    int l = height(root->left);
    int r = height(root->right);
    ans = max(ans, l + r);
    return 1 + max(l, r);
}

int diameterOfBinaryTree(TreeNode* root) {
    height(root);
    return ans;
}

Python Solution
def diameter_of_binary_tree(root):
    ans = 0

    def height(node):
        nonlocal ans
        if not node:
            return 0
        l = height(node.left)
        r = height(node.right)
        ans = max(ans, l + r)
        return 1 + max(l, r)

    height(root)
    return ans''',
  ),
  QuestionItem(
    id: 'IT-Q26',
    industry: 'IT & Software',
    topic: 'Sliding Window',
    question: '''Given a string s, find the length of the longest substring without repeating characters.''',
    shortAnswer: '''Use a sliding window with two pointers (l and r) and a hash map storing characters and their latest indices. Move r through the string, and when a duplicate is found, move l to the position after the last occurrence. Track max window length.''',
    deepExplanation: '''This is the canonical sliding-window question.
Key ideas:
Maintain the window s[l … r], ensuring all characters are unique.


Use a hash map storing char → lastIndex.


If you see a repeated character c at r, move l to max(l, lastIndex[c] + 1).


Update maxLen as r - l + 1.


Example: "abcabcbb"
Traversal:
Window expands → "abc"


At 2nd "a" → move left pointer past previous "a"


Result: 3


Sliding window ensures O(n) complexity.

C++ Solution
int lengthOfLongestSubstring(string s) {
    vector<int> last(256, -1);
    int maxLen = 0, l = 0;

    for (int r = 0; r < s.size(); r++) {
        if (last[s[r]] >= l)
            l = last[s[r]] + 1;
        last[s[r]] = r;
        maxLen = max(maxLen, r - l + 1);
    }
    return maxLen;
}

Python Solution
def length_of_longest_substring(s):
    last = {}
    l = 0
    max_len = 0

    for r, ch in enumerate(s):
        if ch in last and last[ch] >= l:
            l = last[ch] + 1
        last[ch] = r
        max_len = max(max_len, r - l + 1)
    return max_len


Complexity
Time: O(n)


Space: O(1) for ASCII / O(k) for unicode



Common Mistakes
Moving left pointer backwards — never allowed


Resetting entire window on duplicate — inefficient



Tips
Mention sliding window pattern — interviewers love this.''',
  ),
  QuestionItem(
    id: 'IT-Q27',
    industry: 'IT & Software',
    topic: 'Sliding Window + Frequency Count',
    question: '''Given a string s and integer k, you may replace at most k characters to make all characters in a substring identical. Return the length of the longest possible substring.''',
    shortAnswer: '''Use sliding window. Track character frequencies and maintain window size minus max frequency ≤ k. Expand window while this condition holds.''',
    deepExplanation: '''We want the longest substring where:
windowLength - maxFreq ≤ k

Why?
 Because windowLength - maxFreq = number of characters to replace to make entire window the same.
Algorithm:
Expand window to the right.


Track maxFreq → the highest frequency of any character in the window.


If replacements needed exceed k, shrink window from left.


Track max window length.



Python Solution
def character_replacement(s, k):
    freq = {}
    l = 0
    maxf = 0
    res = 0

    for r, ch in enumerate(s):
        freq[ch] = freq.get(ch, 0) + 1
        maxf = max(maxf, freq[ch])

        while (r - l + 1) - maxf > k:
            freq[s[l]] -= 1
            l += 1

        res = max(res, r - l + 1)
    return res

(C++ version similar; omitted for brevity)

Complexity
Time: O(n)


Space: O(1)''',
  ),
  QuestionItem(
    id: 'IT-Q28',
    industry: 'IT & Software',
    topic: 'Hard Sliding Window',
    question: '''Given strings s and t, find the minimum window in s which contains all characters of t.''',
    shortAnswer: '''Use sliding window + frequency requirements. Expand window until all characters of t are satisfied, then shrink from the left to find minimal window. Track the best window found.''',
    deepExplanation: '''This is one of the most famous window problems.
Steps:
Build frequency map of t.


Use two counters:


need → total unique chars needed


have → chars satisfied so far


Expand window (right pointer)


Once all need == have, try shrinking from left


Update minimum window size


Example:
 s="ADOBECODEBANC", t="ABC" → result: "BANC"
This question tests:
Window flexibility


Hash maps


Careful pointer movement



Python Solution (short)
def min_window(s, t):
    from collections import Counter
    need = Counter(t)
    have = {}
    required = len(need)
    formed = 0

    l = 0
    ans = (float('inf'), 0, 0)

    for r, ch in enumerate(s):
        have[ch] = have.get(ch, 0) + 1

        if ch in need and have[ch] == need[ch]:
            formed += 1

        while formed == required:
            if (r - l + 1) < ans[0]:
                ans = (r - l + 1, l, r)

            have[s[l]] -= 1
            if s[l] in need and have[s[l]] < need[s[l]]:
                formed -= 1
            l += 1

    return "" if ans[0] == float('inf') else s[ans[1]:ans[2]+1]''',
  ),
  QuestionItem(
    id: 'IT-Q29',
    industry: 'IT & Software',
    topic: 'Stack',
    question: '''Given two strings s and t, return true if they are equal when both are typed into empty text editors. # means backspace.''',
    shortAnswer: '''Process each string using a stack or two pointers from the end. Apply backspaces and compare final results.''',
    deepExplanation: '''Using stack:
Push normal characters


Pop when encountering #


Optimized approach:
Start from end of both strings


Skip characters using a backspace counter


Compare meaningful characters



Python Solution (two-pointer)
def backspace_compare(s, t):
    def next_valid(i, st):
        skip = 0
        while i >= 0:
            if st[i] == '#':
                skip += 1
            elif skip > 0:
                skip -= 1
            else:
                return i
            i -= 1
        return -1

    i, j = len(s)-1, len(t)-1

    while i >= 0 or j >= 0:
        i = next_valid(i, s)
        j = next_valid(j, t)
        if i >= 0 and j >= 0 and s[i] != t[j]:
            return False
        if (i >= 0) != (j >= 0):
            return False
        i -= 1
        j -= 1
    return True''',
  ),
  QuestionItem(
    id: 'IT-Q30',
    industry: 'IT & Software',
    topic: 'Binary Search on Answer',
    question: '''Given piles of bananas and an integer h, find the minimum eating speed k such that Koko can finish all bananas within h hours.''',
    shortAnswer: '''Binary search k from 1 to max(pile). For each k, compute hours required. If total hours ≤ h, try smaller k; else increase k.''',
    deepExplanation: '''Binary search on answer works when:
Answer lies in a monotonic range


Condition changes from false→true once


Check function:
hours = sum(ceil(pile/k))

If hours <= h, k is valid, try smaller.
Else, increase k.

Python Solution
def min_eating_speed(piles, h):
    import math
    l, r = 1, max(piles)

    def ok(k):
        return sum(math.ceil(p/k) for p in piles) <= h

    while l < r:
        m = (l+r)//2
        if ok(m):
            r = m
        else:
            l = m+1
    return l''',
  ),
  QuestionItem(
    id: 'IT-Q31',
    industry: 'IT & Software',
    topic: 'BST Logic',
    question: '''Find the lowest common ancestor (LCA) of two nodes in a BST.''',
    shortAnswer: '''Use BST property:
If both nodes < root → search left


If both > root → search right


Else → root is LCA''',
    deepExplanation: '''This takes advantage of:
left subtree < root < right subtree

Thus:
If both p and q are on same side → move down


If they diverge → current node is LCA



Python Solution
def lowest_common_ancestor(root, p, q):
    while root:
        if p.val < root.val and q.val < root.val:
            root = root.left
        elif p.val > root.val and q.val > root.val:
            root = root.right
        else:
            return root''',
  ),
  QuestionItem(
    id: 'IT-Q32',
    industry: 'IT & Software',
    topic: 'BFS',
    question: '''Return level order traversal of a binary tree.''',
    shortAnswer: '''Use queue. Add root, then loop: pop node, append its children.''',
    deepExplanation: '''Python Solution
from collections import deque

def level_order(root):
    if not root:
        return []
    q = deque([root])
    res = []
    while q:
        level = []
        for _ in range(len(q)):
            node = q.popleft()
            level.append(node.val)
            if node.left: q.append(node.left)
            if node.right: q.append(node.right)
        res.append(level)
    return res''',
  ),
  QuestionItem(
    id: 'IT-Q33',
    industry: 'IT & Software',
    topic: 'General',
    question: '''Find the maximum depth of a binary tree.''',
    shortAnswer: '''The depth of a node = 1 + max(depth of left, depth of right). Use DFS.''',
    deepExplanation: '''Python Solution
def max_depth(root):
    if not root:
        return 0
    return 1 + max(max_depth(root.left), max_depth(root.right))''',
  ),
  QuestionItem(
    id: 'IT-Q34',
    industry: 'IT & Software',
    topic: 'Grid DFS',
    question: '''Given a grid of 0s and 1s, count number of islands.''',
    shortAnswer: '''Use DFS to mark all connected 1s as visited. Increment island count each time a fresh island is found.''',
    deepExplanation: '''Python Solution
def num_islands(grid):
    if not grid: return 0
    rows, cols = len(grid), len(grid[0])
    visited = set()

    def dfs(r, c):
        if (r,c) in visited or r<0 or c<0 or r>=rows or c>=cols or grid[r][c]=='0':
            return
        visited.add((r,c))
        dfs(r+1,c); dfs(r-1,c)
        dfs(r,c+1); dfs(r,c-1)

    count = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r][c]=='1' and (r,c) not in visited:
                dfs(r,c)
                count += 1

    return count''',
  ),
  QuestionItem(
    id: 'IT-Q35',
    industry: 'IT & Software',
    topic: 'Graph – Topological Sort',
    question: '''Determine if you can finish all courses given prerequisites (detect cycle).''',
    shortAnswer: '''Use DFS or Kahn’s algorithm. Detect cycle in directed graph. If cycle exists → cannot finish.''',
    deepExplanation: '''Python Solution (DFS Cycle)
def can_finish(n, prereq):
    graph = {i: [] for i in range(n)}
    for a,b in prereq:
        graph[b].append(a)

    visited = [0]*n   # 0=unvisited,1=visiting,2=done

    def dfs(node):
        if visited[node] == 1: return False
        if visited[node] == 2: return True
        visited[node] = 1
        for nei in graph[node]:
            if not dfs(nei): return False
        visited[node] = 2
        return True

    return all(dfs(i) for i in range(n))''',
  ),
  QuestionItem(
    id: 'IT-Q36',
    industry: 'IT & Software',
    topic: 'Graph',
    question: '''Deep copy a connected undirected graph.''',
    shortAnswer: '''Use DFS with a hash map storing original → cloned nodes. Recursively clone neighbors.''',
    deepExplanation: '''Python Solution
def clone_graph(node):
    if not node: return None
    mp = {}

    def dfs(n):
        if n in mp: return mp[n]
        copy = Node(n.val)
        mp[n] = copy
        for nei in n.neighbors:
            copy.neighbors.append(dfs(nei))
        return copy

    return dfs(node)''',
  ),
  QuestionItem(
    id: 'IT-Q37',
    industry: 'IT & Software',
    topic: 'Trie',
    question: '''Implement a Trie with insert, search, and prefix search.''',
    shortAnswer: '''Use a tree-like structure with 26 children pointers and a boolean marking end of word.''',
    deepExplanation: '''Python Solution
class TrieNode:
    def __init__(self):
        self.children = {}
        self.end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for c in word:
            if c not in node.children:
                node.children[c] = TrieNode()
            node = node.children[c]
        node.end = True

    def search(self, word):
        node = self.root
        for c in word:
            if c not in node.children:
                return False
            node = node.children[c]
        return node.end

    def startsWith(self, prefix):
        node = self.root
        for c in prefix:
            if c not in node.children:
                return False
            node = node.children[c]
        return True''',
  ),
  QuestionItem(
    id: 'IT-Q38',
    industry: 'IT & Software',
    topic: 'BFS',
    question: '''Given beginWord, endWord, and a dictionary, find the shortest transformation path where only one letter changes at a time.''',
    shortAnswer: '''Use BFS. Preprocess dictionary using wildcard patterns like h*t, ho*. BFS ensures shortest path.''',
    deepExplanation: '''Python Solution
from collections import defaultdict, deque

def ladder_length(begin, end, wordList):
    if end not in wordList:
        return 0

    all_combo = defaultdict(list)
    L = len(begin)

    for w in wordList:
        for i in range(L):
            all_combo[w[:i] + "*" + w[i+1:]].append(w)

    q = deque([(begin, 1)])
    visited = set([begin])

    while q:
        word, level = q.popleft()
        for i in range(L):
            pattern = word[:i] + "*" + word[i+1:]
            for nei in all_combo[pattern]:
                if nei == end:
                    return level + 1
                if nei not in visited:
                    visited.add(nei)
                    q.append((nei, level+1))
    return 0''',
  ),
  QuestionItem(
    id: 'IT-Q39',
    industry: 'IT & Software',
    topic: 'Linked List',
    question: '''Given a linked list L0 → L1 → … → Ln, reorder it to:
 L0 → Ln → L1 → Ln-1 → L2 …''',
    shortAnswer: '''Steps:
Find middle (fast–slow).


Reverse second half.


Merge two halves alternating.''',
    deepExplanation: '''Python Solution
def reorder_list(head):
    if not head: return

    # find mid
    slow, fast = head, head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next

    # reverse second half
    prev = None
    curr = slow.next
    slow.next = None
    while curr:
        nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt

    # merge
    first, second = head, prev
    while second:
        tmp1, tmp2 = first.next, second.next
        first.next = second
        second.next = tmp1
        first, second = tmp1, tmp2''',
  ),
  QuestionItem(
    id: 'IT-Q40',
    industry: 'IT & Software',
    topic: 'Tree',
    question: '''Given a BST, return its kth smallest element.''',
    shortAnswer: '''BST inorder traversal yields sorted order. Do inorder and return the kth element. Or use optimized DFS with counter.''',
    deepExplanation: '''Python Solution
def kth_smallest(root, k):
    stack = []
    while True:
        while root:
            stack.append(root)
            root = root.left
        root = stack.pop()
        k -= 1
        if k == 0:
            return root.val
        root = root.right''',
  ),
  QuestionItem(
    id: 'IT-Q41',
    industry: 'IT & Software',
    topic: 'Heap / Hash Map',
    question: '''Given an integer array nums and an integer k, return the k most frequent elements.''',
    shortAnswer: '''Count the frequency of each number using a hash map.
 Use either:
Max-heap: Push (frequency, number) into a heap and pop k times.


Bucket sort: Create buckets where index = frequency, store numbers accordingly, then iterate from highest frequency downward.


Both solutions produce the top k frequent elements, but bucket sort is optimal at O(n).''',
    deepExplanation: '''This problem tests two key abilities:
1. Understanding Frequency Counting
You must build:
num → count

Example:
 nums = [1,1,1,2,2,3]
 → freq = {1:3, 2:2, 3:1}
2. Choosing Correct Data Structure
There are two valid strategies.

⭐ Approach A — Max-Heap
Build a max-heap ordered by frequency


Push (freq, num) pairs


Pop k times


This works efficiently because heap operations are logarithmic.
Complexity:
 O(n log n)

⭐ Approach B — Bucket Sort (BEST)
Key insight:
 Frequency can only be from 1 to n.
So create:
buckets = list of lists indexed by frequency

Example buckets:
 Index → frequency
 Index 3: [1]
 Index 2: [2]
 Index 1: [3]
Collect from top down until you get k elements.
Complexity:
 O(n)

Examples
Input:
 nums = [4,1,1,2,2,3], k=2
Output:
 [1,2]

C++ Solution (Max-Heap)
vector<int> topKFrequent(vector<int>& nums, int k) {
    unordered_map<int,int> freq;
    for (int num : nums) freq[num]++;

    priority_queue<pair<int,int>> pq;
    for (auto &p : freq) pq.push({p.second, p.first});

    vector<int> result;
    while (k--) {
        result.push_back(pq.top().second);
        pq.pop();
    }
    return result;
}


Python Solution (Heap)
import heapq
from collections import Counter

def top_k_frequent(nums, k):
    freq = Counter(nums)
    heap = []
    for num, f in freq.items():
        heapq.heappush(heap, (-f, num))
    return [heapq.heappop(heap)[1] for _ in range(k)]


Common Mistakes
Sorting entire array by frequency → O(n log n) unnecessary.


Forgetting that pushing negatives to Python heap simulates a max-heap.


Mixing up freq-num vs num-freq order.


Returning duplicate values due to not handling frequency mapping correctly.



Tips
Always mention both methods in interviews. It shows breadth of knowledge.


Bucket sort is the optimal approach — mention why.


Use counter libraries to simplify frequency logic.



Resources
Search: “LeetCode Top K Frequent Elements”


GFG: “K Most Frequent Elements Using Heap”


MIT Lecture: Heap & Priority Queue Basics''',
  ),
  QuestionItem(
    id: 'IT-Q42',
    industry: 'IT & Software',
    topic: 'Heap',
    question: '''Find the k-th largest element in an unsorted array.''',
    shortAnswer: '''Maintain a min-heap of size k.
 Iterate through the array; push each element into the heap.
 If heap size exceeds k, pop the smallest element.
 At the end, the top of the min-heap is the k-th largest element.''',
    deepExplanation: '''This problem checks whether you can identify the correct priority queue direction.
❌ Wrong way:
Sorting entire array → O(n log n)
✔ Correct way: Min-Heap of size k
Heap stores the k largest elements so far


Anything smaller than the smallest in heap is ignored


After processing all numbers, the heap root = kth largest


Example:
 nums = [3,2,1,5,6,4], k = 2
 Heap evolution:
push 3 → [3]


push 2 → [2,3]


push 1 → size>k → pop → [2,3]


push 5 → pop 2 → [3,5]


push 6 → pop 3 → [5,6]
 Top = 5 → answer


This is extremely efficient.

C++ Solution
int findKthLargest(vector<int>& nums, int k) {
    priority_queue<int, vector<int>, greater<int>> pq;

    for (int n : nums) {
        pq.push(n);
        if (pq.size() > k)
            pq.pop();
    }
    return pq.top();
}


Python Solution
import heapq

def kth_largest(nums, k):
    heap = []
    for n in nums:
        heapq.heappush(heap, n)
        if len(heap) > k:
            heapq.heappop(heap)
    return heap[0]


Common Mistakes
Using max-heap and popping k-1 times → more expensive


Sorting — works but not optimal


Forgetting to remove smallest when heap > k


Using wrong heap direction



Tips
Mention alternative quickselect approach (average O(n)).


Min-heap of size k is strongest, simplest interview answer.



Resources
Search: “LeetCode Kth Largest Element in Array”


Algorithm Pattern: Min-Heap of size k


Notes from CLRS: Median & Selection''',
  ),
  QuestionItem(
    id: 'IT-Q43',
    industry: 'IT & Software',
    topic: 'Greedy / Sorting',
    question: '''Given meeting intervals, determine if a person can attend all meetings.''',
    shortAnswer: '''Sort intervals by start time.
 If any interval starts before the previous one ends, there is an overlap → the person cannot attend all meetings.''',
    deepExplanation: '''This problem tests understanding of interval scheduling and how to detect conflicts.
Steps:
Sort intervals by their start time.


Iterate:


Compare current start with previous end


If current.start < previous.end → conflict


Else continue


Example:
Input:
 [[0,30],[5,10],[15,20]]
Sorted:
 [[0,30],[5,10],[15,20]]
Check:
5 < 30 → conflict → return false


Why this works
If you sort by start time, any conflict MUST show up between consecutive intervals.

Python Solution
def can_attend(intervals):
    intervals.sort()
    for i in range(1, len(intervals)):
        if intervals[i][0] < intervals[i-1][1]:
            return False
    return True


C++ Solution
bool canAttendMeetings(vector<vector<int>>& intervals) {
    sort(intervals.begin(), intervals.end());
    for (int i = 1; i < intervals.size(); i++) {
        if (intervals[i][0] < intervals[i-1][1])
            return false;
    }
    return true;
}


Common Mistakes
Sorting by end time instead of start time


Allowing negative durations (invalid intervals)


Assuming equal endpoints cause conflict (end == start is OK)



Tips
The trick is recognizing this is the simplest interval overlap pattern.


You can extend logic for “Meeting Rooms II” problem if asked.



Resources
Search: “LeetCode Meeting Rooms”


MIT Greedy Algorithms Lecture


Interval Scheduling Problem Notes''',
  ),
  QuestionItem(
    id: 'IT-Q44',
    industry: 'IT & Software',
    topic: 'Heap / Linked List',
    question: '''Merge k sorted linked lists into one single sorted linked list and return it.''',
    shortAnswer: '''Use a min-heap to always extract the smallest head among the k lists.
 Push the head of each list into the heap.
 Repeatedly pop the smallest node, append it to the merged list, and push its next node.
 Time complexity is O(N log k), where N is total nodes.''',
    deepExplanation: '''This is one of the most important LinkedList + Heap problems.
 Why a heap?
Because we need to repeatedly extract the minimum among k sorted lists.
 A min-heap makes this operation efficient.
Process Overview:
Initialize a min-heap storing (node value, list index, node pointer)


Push each list’s head node.


While heap not empty:


Pop the smallest element


Append it to result list


Push popped node’s next (if exists)


Return the merged list


Why log k?
Each push/pop on the heap of size k costs log k.
 And we process every node exactly once → O(N log k).
Example
Given:
List₁: 1 → 4 → 5


List₂: 1 → 3 → 4


List₃: 2 → 6


Heap evolution:
 Push (1,1), (1,2), (2,3) → pop 1 → push next 4 → …
Final:
 1 → 1 → 2 → 3 → 4 → 4 → 5 → 6

Python Solution
import heapq

def merge_k_lists(lists):
    heap = []
    for idx, node in enumerate(lists):
        if node:
            heapq.heappush(heap, (node.val, idx, node))

    dummy = ListNode(0)
    curr = dummy

    while heap:
        val, idx, node = heapq.heappop(heap)
        curr.next = node
        curr = curr.next
        if node.next:
            heapq.heappush(heap, (node.next.val, idx, node.next))

    return dummy.next


C++ Solution
struct cmp {
    bool operator()(ListNode* a, ListNode* b) {
        return a->val > b->val;
    }
};

ListNode* mergeKLists(vector<ListNode*>& lists) {
    priority_queue<ListNode*, vector<ListNode*>, cmp> pq;

    for (auto node : lists)
        if (node) pq.push(node);

    ListNode dummy(0), *tail = &dummy;

    while (!pq.empty()) {
        ListNode* node = pq.top();
        pq.pop();
        tail->next = node;
        tail = tail->next;

        if (node->next)
            pq.push(node->next);
    }

    return dummy.next;
}


Common Mistakes
Forgetting to push node->next into heap


Using sorting for each insert → O(n log n) unnecessary


Confusing min-heap with max-heap


Not including list index in Python tuple (causes comparison errors)



Tips
Mention complexity explicitly: O(N log k)


Heap + LinkedList is a classic pairing


If interviewer asks for alternative: divide & conquer merge (O(N log k))



Resources
LeetCode 23 “Merge K Sorted Lists”


Stanford Lecture: Priority Queues


GFG: Merge k Sorted Lists''',
  ),
  QuestionItem(
    id: 'IT-Q45',
    industry: 'IT & Software',
    topic: 'Binary Search on Slopes',
    question: '''A peak element is one that is strictly greater than its neighbors.
 Return any peak element’s index in an array.''',
    shortAnswer: '''Use binary search on the slope:
If nums[mid] < nums[mid+1], move right → peak lies right


Else, move left → peak lies left or at mid
 Binary search continues until left == right, which is a peak.''',
    deepExplanation: '''This question tests whether you recognize that the array behaves like a landscape of slopes.
Key idea:
 If you're on a rising slope, a peak must be ahead.
 If on a falling slope, a peak must be behind.
Why binary search works?
Because:
If nums[mid] < nums[mid+1] → slope rising → peak on right


If nums[mid] > nums[mid+1] → slope falling → peak on left


Eventually, search converges on one peak, guaranteed.
Example
nums = [1,2,1,3,5,6,4]
 Possible peaks: index 1 (2), index 5 (6)
Binary search finds any valid peak.
Complexity
O(log n)

Python Solution
def find_peak(nums):
    l, r = 0, len(nums)-1
    while l < r:
        m = (l + r) // 2
        if nums[m] < nums[m+1]:
            l = m + 1
        else:
            r = m
    return l


C++ Solution
int findPeakElement(vector<int>& nums) {
    int l = 0, r = nums.size() - 1;
    while (l < r) {
        int m = (l + r) / 2;
        if (nums[m] < nums[m+1])
            l = m + 1;
        else
            r = m;
    }
    return l;
}


Common Mistakes
Trying to check all neighbors manually


Using linear scan → O(n), misses binary search expectation


Assuming only one peak


Overthinking array boundaries



Tips
This is not a mountain array; just find any peak


The logic is similar to “Find local maxima in unimodal function”


Mention that array edges are valid peaks



Resources
LeetCode 162 “Find Peak Element”


MIT OpenCourseWare: Binary Search Variants


GFG: Binary Search on Answer''',
  ),
  QuestionItem(
    id: 'IT-Q46',
    industry: 'IT & Software',
    topic: 'Stack',
    question: '''Evaluate the value of an arithmetic expression in Reverse Polish Notation (postfix).
Valid operators are +, -, *, /.
 Division between two integers truncates toward zero.''',
    shortAnswer: '''Use a stack. For each token:
If number → push


If operator → pop top two numbers, apply operator, push result back
 At end, stack contains single result.''',
    deepExplanation: '''Reverse Polish Notation removes the need for parentheses by defining clear operand order.
Given tokens like:
["2","1","+","3","*"]

Evaluate as:
 (2 + 1) * 3 = 9
Algorithm:
Loop through each token


If token is a number → push


If token is operator →


Pop right operand b


Pop left operand a


Compute a op b


Push result


Final answer = stack top


Example:
 Input: ["4","13","5","/","+"]
 → (13 / 5) = 2 → 4 + 2 = 6

Python Solution
def eval_rpn(tokens):
    stack = []
    for t in tokens:
        if t not in "+-*/":
            stack.append(int(t))
        else:
            b = stack.pop()
            a = stack.pop()
            if t == "+": stack.append(a + b)
            elif t == "-": stack.append(a - b)
            elif t == "*": stack.append(a * b)
            else: stack.append(int(a / b))  # truncates toward 0
    return stack[0]


C++ Solution
int evalRPN(vector<string>& tokens) {
    stack<long long> st;
    for (string &t : tokens) {
        if (t=="+" || t=="-" || t=="*" || t=="/") {
            long long b = st.top(); st.pop();
            long long a = st.top(); st.pop();
            if (t == "+") st.push(a + b);
            else if (t == "-") st.push(a - b);
            else if (t == "*") st.push(a * b);
            else st.push(a / b);
        } else {
            st.push(stoll(t));
        }
    }
    return st.top();
}


Common Mistakes
Reversing operand order (a op b vs b op a)


Mishandling division (must truncate toward 0)


Using float division instead of integer division


Modifying tokens list during iteration



Tips
Always check operand order in stack-based problems


Mention how postfix avoids parentheses


Practice with sample expressions before coding



Resources
LeetCode 150 “Evaluate Reverse Polish Notation”


Stanford CS103: Stack Evaluation Notes


GFG: Postfix Evaluation''',
  ),
  QuestionItem(
    id: 'IT-Q47',
    industry: 'IT & Software',
    topic: 'Graph / Two-pointer Reduction',
    question: '''A celebrity is someone who:
Everyone knows


They know no one


Given a function knows(a, b) that returns true if person a knows person b, determine the celebrity among n people (or return -1 if none exists).''',
    shortAnswer: '''Use two-pointer elimination:
Start with two people a=0, b=n-1.


If a knows b, a cannot be a celebrity → increment a.


Else b cannot be a celebrity → decrement b.
 This yields one candidate.
 Finally, verify candidate by checking both conditions.''',
    deepExplanation: '''This problem seems like a graph problem, because you can imagine:
An edge from A → B means A knows B


A celebrity has:


In-degree = n–1


Out-degree = 0


Naive approach:
Check all pairs → O(n²)
⭐ Optimal approach (Two-pointer Elimination): O(n)
The idea:
Compare two people at a time


If person A knows person B → A cannot be celebrity


If A does NOT know B → B cannot be celebrity
 One comparison eliminates exactly one candidate ⇒ O(n)


Once only one candidate remains, verify by checking:
Candidate knows nobody


Everybody knows candidate


If either check fails → return -1
Example
People: 0,1,2,3
 Candidate elimination yields candidate = 2
 Verify → if all conditions match → 2 is celebrity.

Python Solution
def find_celebrity(n, knows):
    a, b = 0, n-1
    while a < b:
        if knows(a, b):
            a += 1
        else:
            b -= 1

    cand = a
    for i in range(n):
        if i != cand:
            if knows(cand, i) or not knows(i, cand):
                return -1
    return cand


C++ Solution
int findCelebrity(int n) {
    int a = 0, b = n - 1;

    while (a < b) {
        if (knows(a, b)) a++;
        else b--;
    }

    int cand = a;
    for (int i = 0; i < n; i++) {
        if (i != cand) {
            if (knows(cand, i) || !knows(i, cand))
                return -1;
        }
    }
    return cand;
}


Common Mistakes
Forgetting that the final candidate MUST be fully verified


Assuming multiple celebrities can exist (only one possible)


Reversing the logic: “A knows B” eliminates A, NOT B


Trying to build adjacency matrix → memory waste



Tips
Mention "elimination reduces search to O(n)" → big plus in interviews


Do NOT skip verification step


Understand the graph interpretation (in-degree = n–1, out-degree = 0)



Resources
Stanford Intro to Algorithms – Celebrity Problem


LeetCode #277 “Find the Celebrity”


GFG: Celebrity Problem (Two-pointer method)''',
  ),
  QuestionItem(
    id: 'IT-Q48',
    industry: 'IT & Software',
    topic: 'Dynamic Programming',
    question: '''Given an integer array nums, find the contiguous subarray with the maximum sum and return the sum.''',
    shortAnswer: '''Use Kadane’s algorithm:
 At each index, decide whether to start a new subarray or extend the previous one.
 Track a running maximum and return the global maximum.''',
    deepExplanation: '''This is one of the most elegant DP problems.
We define:
current = max(nums[i], current + nums[i])
best = max(best, current)

Interpretation:
Either extend previous subarray


Or start fresh from current index


Maintain best seen so far


Example
nums = [-2,1,-3,4,-1,2,1,-5,4]
Running steps:
current = -2, best = -2


current = 1, best = 1


current = -2, best = 1


current = 4, best = 4


current = 3, best = 4


current = 5, best = 5


current = 6, best = 6
 Final answer = 6



Python Solution
def max_subarray(nums):
    current = best = nums[0]
    for x in nums[1:]:
        current = max(x, current + x)
        best = max(best, current)
    return best


C++ Solution
int maxSubArray(vector<int>& nums) {
    int current = nums[0], best = nums[0];
    for (int i = 1; i < nums.size(); i++) {
        current = max(nums[i], current + nums[i]);
        best = max(best, current);
    }
    return best;
}


Common Mistakes
Restarting subarray incorrectly when encountering negative numbers


Using nested loops → O(n²)


Misunderstanding that array may contain all negatives



Tips
Kadane’s algorithm is a classic DP — mention that


Works for both positive and negative series


Understand intuition, not just formula



Resources
MIT: Kadane’s Algorithm Explanation


LeetCode #53 “Maximum Subarray”


GFG: Maximum Subarray Sum (Kadane)''',
  ),
  QuestionItem(
    id: 'IT-Q49',
    industry: 'IT & Software',
    topic: 'Backtracking / DFS',
    question: '''Given a string s, partition it into all possible lists of substrings such that each substring is a palindrome.''',
    shortAnswer: '''Use DFS + backtracking.
 At each index, expand all possible substrings; if substring is palindrome, include it and recurse on the remainder.
 Collect all valid partitions.''',
    deepExplanation: '''The goal is to explore all palindromic partitions.
 This is a classic DFS/backtracking challenge.
Key observations:
Checking palindrome is O(n)


There are exponential combinations


Backtracking enables exploring all valid partitions


The recursive process:
Start at index i=0


For each j from i to end:


Check if s[i:j+1] is palindrome


If yes, include in path and recurse from j+1


If index == len(s), one valid partition is complete


Example:
 s = "aab"
Partitions:
["a","a","b"]


["aa","b"]



Python Solution
def partition(s):
    res = []

    def is_pal(x):
        return x == x[::-1]

    def dfs(i, path):
        if i == len(s):
            res.append(path[:])
            return
        for j in range(i, len(s)):
            if is_pal(s[i:j+1]):
                dfs(j+1, path + [s[i:j+1]])

    dfs(0, [])
    return res


C++ Solution
class Solution {
public:
    bool isPal(string &s, int l, int r) {
        while (l < r) {
            if (s[l] != s[r]) return false;
            l++; r--;
        }
        return true;
    }

    void dfs(int start, string &s, vector<string> &path, vector<vector<string>> &res) {
        if (start == s.size()) {
            res.push_back(path);
            return;
        }
        for (int end = start; end < s.size(); end++) {
            if (isPal(s, start, end)) {
                path.push_back(s.substr(start, end-start+1));
                dfs(end+1, s, path, res);
                path.pop_back();
            }
        }
    }

    vector<vector<string>> partition(string s) {
        vector<vector<string>> res;
        vector<string> path;
        dfs(0, s, path, res);
        return res;
    }
};


Common Mistakes
Forgetting to backtrack (need to pop last element)


Checking palindrome incorrectly


Using slicing repeatedly in C++ (expensive)


Thinking dynamic programming is required (not needed)



Tips
Precomputing palindrome table can optimize to O(n²)


Backtracking + pruning = clean solution


Mention time complexity exponential nature



Resources
LeetCode #131 “Palindrome Partitioning”


MIT Backtracking Lecture


GFG: Palindrome Partition Problem''',
  ),
];
