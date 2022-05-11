---
title: "Binary Search for Technical Interviews"
description: "Learn how to effectively use binary search algorithm, solving frequently-asked technical interview problems."
image: "/images/binary-search-tech-interviews/binary-search-preview.png"
date: 2022-05-11
canonicalUrl: "https://medium.com/@almmiko/binary-search-for-technical-interviews-27861a823101"
canonicalUrlText: "https://medium.com/@almmiko"
---

![Binary search](/images/binary-search-tech-interviews/binary-search-preview.png)

Binary search algorithm is a widely used searching algorithm to find data in a **sorted** collection.

Binary search is also referred to as half-interval search. If you can, roughly, eliminate half of the search area with a condition (invariant), you can use binary search to find the target solution.

The algorithm runs in **O(log n)** in worst and average cases, making it efficient for solving many search-related problems.

You can implement it _iteratively_ or _recursively_. In this article, you will use iterative implementation to have **O(1)** space complexity.

The primary examples of binary search usage show how to implement it and find some data in a sorted collection. However, the algorithm can be used in more complicated scenarios.

For example, the algorithm can be used to solve the following problem types:

- find the maximum element not greater than x (leftmost element)
- find the minimum element not less than x (rightmost element)
- find the kth element
- minimax problems
- maximize/minimize the arithmetic mean of a subset with some properties

At the first look, binary search can be straightforward to implement. However, the real-world usage showed the opposite.

> "Although the basic idea of binary search is comparatively straightforward, the details can be surprisingly tricky". — Donald Knuth

The famous issue with a tricky implementation related to number overflow when calculating a middle point `(left + right) / 2`. The problem affected many textbooks and programming language implementations.

If you are interested to learn more about the overflow issue, check the Google research blog [Nearly All Binary Searches and Mergesorts are Broken](http://ai.googleblog.com/2006/06/extra-extra-read-all-about-it-nearly.html "Extra, Extra - Read All About It: Nearly All Binary Searches and Mergesorts are Broken") which shows details of that problem.

Also, common issues with using binary search to solve interview problems are related to edge cases such as:

- left pointer is pointing to the solution
- right pointer is pointing to the solution
- pointer is out of the collection range
- the invariant doesn't cover rare inputs

It's critical to understand and be able to implement variations of binary search depending on the problem you need to solve.

In this article, you will learn how to implement binary search and use it to solve real interview problems.

## Binary Search Implementation

Before solving problems, you need to understand how binary search works and implement the algorithm.

For the explanation, I will use pseudocode and, for problems solution Rust, but the implementation would be similar to other programming languages.

First, you need to have a sorted collection or, in more complicated scenarios sorted slice (subcollection). A collection can be sorted in ascending on descending order. The order will impact conditions where you should move `left` and `right` pointers.

The search starts by comparing elements in the `middle` of the collection with the target value.

To find the middle use `middle = left + (right - left) / 2`. This formula calculates the middle point and is a safe way of doing it. It will protect you from having an overflow issue.

The `left` pointer initially holds zero as an index, and the `right` pointer takes the collection size.

```plaintext
left = 0;
right = arr.len();
```

In many problems you may see that `left` and `right` pointers are pointing outside of the collection or represent the search space for the problems not related to arrays.

Setting `left` and `right` pointers outside the collections can be helpful in some cases and may simplify the code, but you have to be careful when accessing the collection values using `left` and `right` pointers. If they point to values that are not valid indexes(collection bounds), you will get an **index out of bounds** error.

```plaintext
left = -1
right = arr.len()
```

When you calculate the `middle` value, compare it with the target value, and if it matches, you have found the seeking value.

```plaintext
if arr[middle] == target { return middle }
```

If the `arr[middle] < target` satisfies, the search continues in the right half of the collection; otherwise, it searches in the left half.

```plaintext
if arr[middle] < target {
    left = middle + 1
} else {
    right = middle
}
```

On each iteration, the algorithm eliminates half of the collection in which the target value can't be found.

```plaintext
left = 0
right = arr.len()

while left < right {
    middle = left + (right - left) / 2

    if nums[middle] == target {
        return middle
    }

    if arr[middle] < target {
        //the searched value in the right part
        left = middle + 1
    } else {
        // the searched value in the left part
        right = middle
    }
}

// In the case when the element is not found
return -1
```

The algorithm steps can be summarised as follows:

- The `left` pointer points to the `0` index (in most cases)
- The `right` pointer points to the collection size
- The `while` loop condition is `left < right`
- Move the `left` or `right` index to the `middle` index

Note that the above binary search implementation is one of the many possible implementations. Of course, not every problem can be solved with one common pattern, but when you try to consider the specifics of each problem, you can easily fail with tricky edge cases.

The next step is to apply your knowledge to solve frequently-asked binary search problems.

## Binary Search Problems

Many binary search problems are written in a way that, on the first look, it's not clear when binary search can be used. The complexity can be defining a search condition or even doing unrelated to binary search manipulations to transform the input data before applying binary search. However, pay attention to small details.
When you see a problem that requires a solution with `O(log n)` or sequence is sorted or can be sorted, this can be a good indicator of possible binary search usage.

Alright, let's try to solve some binary search problems. I would encourage you to solve them on your own and then check the solution.

### Find First and Last Position of Element in Sorted Array

> Given an array of integers `nums` sorted in non-decreasing order, find the starting and ending position of a given `target` value.
>
> If `target` is not found in the array, return `[-1, -1]`.
>
> You must write an algorithm with `O(log n)` runtime complexity.

Source: [Leetcode](https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/)

#### Solution

To solve this problem, you first need to solve two subproblems. The solution to the subproblems will be the solution to the main problem.

The subproblems are:

- find the leftmost element (`lower_bound`)
- find the rightmost element (`upper_bound`)

To find `lower_bound`, you can use binary search algorithm to return `left` index. After search completion, it's guaranteed that the `left` pointer will point to a seeking target element if the element exists.

```rust
pub fn lower_bound(nums: &[i32], target: i32) -> i32 {
    let mut l = 0;
    let mut r = nums.len();

    while l < r {
        let m = l + (r - l) / 2;

        if nums[m] < target {
            l = m + 1;
        } else {
            r = m;
        }
    }

    l as i32
}
```

Finding `upper_bound` can be tricky. The array is sorted in non-decreasing order, meaning that we need to find an element from the right side. You need to change the pointer moving condition to find the rightmost element.

If the `middle` element is greater than the target, you move `right` to the `middle` and continue searching on the left part. Otherwise, on the right part.

```rust
if nums[m] > target {
    r = m;
} else {
    l = m;
}
```

When the loop `while l + 1 < r` completes, the `left` and the `right` pointers will hold the indexes of the adjacent elements, and the `left` pointer value is the rightmost element's index.

```rust
pub fn upper_bound(nums: &[i32], target: i32) -> i32 {
    let mut l = 0;
    let mut r = nums.len();

    while l + 1 < r {
        let m = l + (r - l) / 2;

        if nums[m] > target {
            r = m;
        } else {
            l = m;
        }
    }

    l as i32
}
```

Now, when you have functions to find `lower_bound` and `upper_bound` you can use them to find the final result.

```rust
let l = lower_bound(&nums, target);
let r = upper_bound(&nums, target);
```

The `left` index from the `lower_bound` function result can be outside the array length or point to a not-target array element. To prevent **out of index** error and check if the target value exists, you need to check if `left` is in the array size bounds and `nums[l] != target`. If any of those conditions are true, return `[-1, -1]`.

```rust
if l == size || nums[l as usize] != target {
    return vec![-1, -1];
}
```

The completed solution code.

```rust
pub fn lower_bound(nums: &[i32], target: i32) -> i32 {
    let mut l = 0;
    let mut r = nums.len();

    while l < r {
        let m = l + (r - l) / 2;

        if nums[m] < target {
            l = m + 1;
        } else {
            r = m;
        }
    }

    l as i32
}

pub fn upper_bound(nums: &[i32], target: i32) -> i32 {
    let mut l = 0;
    let mut r = nums.len();

    while l + 1 < r {
        let m = l + (r - l) / 2;

        if nums[m] > target {
            r = m;
        } else {
            l = m;
        }
    }

    l as i32
}

pub fn search_range(nums: Vec<i32>, target: i32) -> Vec<i32> {
    let size = nums.len() as i32;

    if size == 0 {
        return vec![-1, -1];
    }

    let l = lower_bound(&nums, target);
    let r = upper_bound(&nums, target);

    if l == size || nums[l as usize] != target {
        return vec![-1, -1];
    }

    vec![l, r]
}
```

### Search in Rotated Sorted Array

> There is an integer array `nums` sorted in ascending order (with **distinct** values).
>
> Prior to being passed to your function, `nums` is **possibly rotated** at an unknown pivot index `k` (`1 <= k < nums.length`) such that the resulting array is `[nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]` (**0-indexed**). For example, `[0,1,2,4,5,6,7]` might be rotated at pivot index `3` and become `[4,5,6,7,0,1,2]`.
>
> Given the array `nums` **after** the possible rotation and an integer `target`, return *the index of* `target` *if it is in* `nums`*, or* `-1` *if it is not in* `nums`.
>
> You must write an algorithm with `O(log n)` runtime complexity.

Source: [Leetcode](https://leetcode.com/problems/search-in-rotated-sorted-array/)

#### Solution

In this problem, the `nums` array possibly can be rotated, meaning you will have two sorted chunks. The adjacent elements, after rotation, will form a peak and drop. If you find the peak, you can apply binary search on the left and the right parts of the peak to find the target value.

![binary-search-peak](/images/binary-search-tech-interviews/binary-search-peak.png)

So how do you find the peak value? If the array is sorted in ascending order, it means the value `nums[m]` is greater than `nums[m - 1]`, and if the sequence is without rotation, the most left value is less than `nums[m]`. If the most left value ( `nums[l]`) is greater than `nums[m]` means that the peak value is in the left part; otherwise in the right part.

```rust
let size = nums.len();

let mut l = 0;
let mut r = size;

while l + 1 < r {
    let m = l + (r - l) / 2;

    if nums[m] > nums[m - 1] && nums[m] > nums[l] {
        l = m;
    } else {
        r = m;
    }
}

let pivot = l;
```

After finding the peak value (pivot), the problem is reduced to finding the element in the subarray from the left part of the pivot and the right part.

```rust
&nums[0..=pivot]
&nums[pivot + 1..]
```

To find the target element, you can implement binary search, but in Rust, you can use a standard implementation, which will simplify the code.

```rust
if let Ok(idx) = &nums[0..=pivot].binary_search(&target) {
    return *idx as i32;
}

if let Ok(idx) = &nums[pivot + 1..].binary_search(&target) {
    return (*idx + l + 1) as i32;
}
```

If the target element is found on the left or right part, return it index.

The completed solution code.

```rust
pub fn search(nums: Vec<i32>, target: i32) -> i32 {
    let size = nums.len();

    let mut l = 0;
    let mut r = size;

    while l + 1 < r {
        let m = l + (r - l) / 2;

        if nums[m] > nums[m - 1] && nums[m] > nums[l] {
            l = m;
        } else {
            r = m;
        }
    }

    let pivot = l;

    if let Ok(idx) = &nums[0..=pivot].binary_search(&target) {
        return *idx as i32;
    }

    if let Ok(idx) = &nums[pivot + 1..].binary_search(&target) {
        return (*idx + l + 1) as i32;
    }

    -1
}
```

## Wrapping up

Binary search is an efficient search algorithm and can be used to solve various problems. Still, you need to be able to evaluate possible edge cases and adapt binary search implementation to find the desired solution.

Luckily, you have a lot of free resources to practice binary search problems.

Leetcode provides the [study plan](https://leetcode.com/study-plan/binary-search/) and the collection of [binary-search](https://leetcode.com/tag/binary-search/)problems.

You also can try to solve [competitive programming problems](https://codeforces.com/problemset?order=BY_RATING_ASC&tags=binary+search) from Codeforces related to binary search. Remember that Codeforces problems can be tough to solve and require knowledge from different topics that are not covered in this article.

Don't be discouraged when you cannot solve any of the problems. Leetcode problems with an easy tag don't mean they are easy.

Keep practicing, and eventually, the problems you saw hard to solve become obvious to you.
